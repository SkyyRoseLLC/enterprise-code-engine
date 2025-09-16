\from fastapi import FastAPI
from pydantic import BaseModel
import subprocess
import tempfile
import os

app = FastAPI()

class CodeRequest(BaseModel):
    language: str
    code: str
    input: str = ""

@app.post("/v1/execute")
def run_code(request: CodeRequest):
    runners = {
        "python": ["python3"],
    }

    if request.language not in runners:
        return {"error": f"Unsupported language: {request.language}"}

    suffix_map = {
        "python": ".py",
        "go": ".go",
        "java": ".java",
        "csharp": ".csx"
    }

    suffix = suffix_map.get(request.language, ".txt")

    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
        tmp.write(request.code.encode("utf-8"))
        tmp.flush()

        try:
            if request.language == "java":
                subprocess.run(["javac", tmp.name], check=True)
                run_name = tmp.name.replace(".java", "")
                result = subprocess.run(
                    ["java", run_name],
                    input=request.input.encode(),
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    timeout=5
                )
            else:
                result = subprocess.run(
                    runners[request.language] + [tmp.name],
                    input=request.input.encode(),
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    timeout=5
                )

            return {
                "stdout": result.stdout.decode(),
                "stderr": result.stderr.decode(),
                "exitCode": result.returncode
            }
        except Exception as e:
            return {"error": str(e)}
        finally:
            os.unlink(tmp.name)


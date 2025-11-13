from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "CRM Fiori Backend OK"}

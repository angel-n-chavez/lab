from fastapi import FastAPI

app = FastAPI(title="Devops Utils API")

@app.get("/hello")  # decorator for when someone goes to https://myurl.com/hello it will call the hello() function
def hello():
    return{"message" : "Hello Angel, Welcom To Devops Utils API"}

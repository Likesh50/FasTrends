import azure.functions as func
from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

@app.route('/scrape', methods=['POST'])
def scrape():
    data = request.get_json()
    query = data.get('query', 'steel')
    URL = f"https://techcrunch.com/?s={query}"
    r = requests.get(URL)
    soup = BeautifulSoup(r.content, 'html.parser')
    a_tags = soup.find_all('a', attrs={'data-destinationlink': True})

    links = [tag['data-destinationlink'] for tag in a_tags]
    return jsonify(links)

def main(req: func.HttpRequest) -> func.HttpResponse:
    with app.app_context():
        response = app.full_dispatch_request()
        return func.HttpResponse(response.response[0], status_code=response.status_code)

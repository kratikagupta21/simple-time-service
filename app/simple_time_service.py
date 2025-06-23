from flask import Flask, request, Response
from datetime import datetime
from collections import OrderedDict
import json

app = Flask(__name__)

@app.route('/', methods=['GET'])
def time_service():
    # Attempt to get real client IP from headers
    x_forwarded_for = request.headers.get('X-Forwarded-For')
    if x_forwarded_for:
        visitor_ip = x_forwarded_for.split(',')[0].strip()
    else:
        visitor_ip = request.remote_addr

    # Print visitor IP to server console
    print(f"[INFO] Visitor IP: {visitor_ip}")

    current_time = datetime.utcnow().isoformat() + 'Z'
    response_data = OrderedDict([
        ("timestamp", current_time),
        ("ip", visitor_ip)
    ])

    return Response(
        json.dumps(response_data),
        mimetype='application/json'
    )

if __name__ == '__main__':
    print("SimpleTimeService is running on http://0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000)

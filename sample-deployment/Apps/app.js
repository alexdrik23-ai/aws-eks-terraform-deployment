const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 3000;

const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EKS Sample App</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
    }
    .card {
      background: rgba(255,255,255,0.07);
      backdrop-filter: blur(12px);
      border: 1px solid rgba(255,255,255,0.15);
      border-radius: 20px;
      padding: 48px 56px;
      max-width: 600px;
      width: 90%;
      text-align: center;
      box-shadow: 0 24px 64px rgba(0,0,0,0.4);
    }
    .badge {
      display: inline-block;
      background: #00d4aa;
      color: #000;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 2px;
      text-transform: uppercase;
      padding: 4px 14px;
      border-radius: 20px;
      margin-bottom: 24px;
    }
    h1 {
      font-size: 2.4rem;
      font-weight: 700;
      margin-bottom: 12px;
      background: linear-gradient(90deg, #00d4aa, #7b61ff);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    p.subtitle {
      color: rgba(255,255,255,0.6);
      font-size: 1rem;
      margin-bottom: 36px;
    }
    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 32px;
    }
    .info-box {
      background: rgba(255,255,255,0.05);
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 12px;
      padding: 16px;
      text-align: left;
    }
    .info-box .label {
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #00d4aa;
      margin-bottom: 6px;
    }
    .info-box .value {
      font-size: 13px;
      color: rgba(255,255,255,0.85);
      word-break: break-all;
    }
    .status {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-size: 14px;
      color: rgba(255,255,255,0.5);
    }
    .dot {
      width: 8px; height: 8px;
      border-radius: 50%;
      background: #00d4aa;
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.5; transform: scale(1.3); }
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="badge">🚀 Running on AWS EKS</div>
    <h1>Hello from Kubernetes!</h1>
    <p class="subtitle">Your sample app is live and serving traffic through the AWS ALB Ingress.</p>
    <div class="info-grid">
      <div class="info-box">
        <div class="label">Pod Name</div>
        <div class="value">POD_NAME_PLACEHOLDER</div>
      </div>
      <div class="info-box">
        <div class="label">Node</div>
        <div class="value">NODE_NAME_PLACEHOLDER</div>
      </div>
      <div class="info-box">
        <div class="label">Namespace</div>
        <div class="value">NAMESPACE_PLACEHOLDER</div>
      </div>
      <div class="info-box">
        <div class="label">Version</div>
        <div class="value">v1.0.0</div>
      </div>
    </div>
    <div class="status">
      <div class="dot"></div>
      Healthy · Port PORT_PLACEHOLDER
    </div>
  </div>
</body>
</html>`;

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  const page = html
    .replace('POD_NAME_PLACEHOLDER', os.hostname())
    .replace('NODE_NAME_PLACEHOLDER', process.env.NODE_NAME || 'unknown')
    .replace('NAMESPACE_PLACEHOLDER', process.env.POD_NAMESPACE || 'unknown')
    .replace('PORT_PLACEHOLDER', PORT);

  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(page);
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
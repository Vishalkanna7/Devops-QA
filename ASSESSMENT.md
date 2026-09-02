# DevOps Support & QA Engineer Assessment

## Delivered

- User-facing branding is MyTemplate; internal package and asset identifiers remain unchanged.
- `GET /health` returns `{"status":"ok"}` with a backend pytest test.
- The public landing page has a headless Playwright flow that verifies MyTemplate, then follows Demo to signup.
- The decorative hero overlay no longer blocks the Demo CTA.
- Token-salt derivation uses SHA-256 instead of MD5.

The SHA-256 change is required by this assessment. Because the existing token
salt was derived with MD5, previously issued email-confirmation, password-reset,
or license tokens may not decode after deployment. There is no token migration
mechanism in this application, so outstanding tokens may need to be reissued.
This change does not modify passwords or database hashing.

## Repeatable quality pipeline

`make quality` (Linux/macOS/CI) produces:

- `reports/junit.xml`
- `reports/coverage.xml` and `reports/htmlcov/`
- `reports/ruff.json`
- `reports/bandit.json`
- `reports/playwright/` when Playwright produces test output

Windows PowerShell equivalent:

```powershell
New-Item -ItemType Directory -Force reports
.\env\Scripts\python.exe -m pytest tests --ignore=tests/test_ui_landing.py --junitxml=reports/junit.xml --cov=appname --cov-report=xml:reports/coverage.xml --cov-report=html:reports/htmlcov
.\env\Scripts\python.exe -m pytest tests/test_ui_landing.py --browser chromium --output=reports/playwright
.\env\Scripts\python.exe -m ruff check . --output-format=json > reports/ruff.json
.\env\Scripts\python.exe -m bandit -r appname -f json -o reports/bandit.json
```

Install the browser once per machine with `python -m playwright install chromium`. GitHub Actions runs the same pipeline on Python 3.12 and uploads `reports/` even when a check fails.

AWS deployment was intentionally not added; it is a bonus and comes after this verified pipeline.

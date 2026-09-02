PYTHON ?= python
REPORTS_DIR ?= reports

.PHONY: test ui lint security quality

$(REPORTS_DIR):
	mkdir -p $(REPORTS_DIR)

test: $(REPORTS_DIR)
	$(PYTHON) -m pytest tests --ignore=tests/test_ui_landing.py --junitxml=$(REPORTS_DIR)/junit.xml --cov=appname --cov-report=xml:$(REPORTS_DIR)/coverage.xml --cov-report=html:$(REPORTS_DIR)/htmlcov

ui: $(REPORTS_DIR)
	$(PYTHON) -m pytest tests/test_ui_landing.py --browser chromium --output=$(REPORTS_DIR)/playwright

lint: $(REPORTS_DIR)
	$(PYTHON) -m ruff check . --output-format=json > $(REPORTS_DIR)/ruff.json

security: $(REPORTS_DIR)
	$(PYTHON) -m bandit -r appname -f json -o $(REPORTS_DIR)/bandit.json

quality: test ui lint security

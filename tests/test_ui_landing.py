import threading

import pytest
from playwright.sync_api import expect
from werkzeug.serving import make_server

from appname import create_app


@pytest.fixture()
def live_server():
    app = create_app("appname.settings.TestConfig")
    server = make_server("127.0.0.1", 0, app)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()

    yield f"http://127.0.0.1:{server.server_port}"

    server.shutdown()
    thread.join()


def test_landing_page_branding_and_demo_signup_flow(page, live_server):
    page.goto(live_server, wait_until="domcontentloaded")

    expect(page).to_have_title("MyTemplate")
    expect(page.get_by_test_id("landing-brand")).to_have_text("MyTemplate")
    expect(page.get_by_role("heading", name="Batteries Included")).to_be_visible()

    page.get_by_test_id("landing-demo").click()

    expect(page).to_have_url(f"{live_server}/signup")

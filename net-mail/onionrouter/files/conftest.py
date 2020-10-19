from __future__ import unicode_literals
import pytest
import io
try:
    import configparser
except ImportError:
    import ConfigParser as configparser
from onionrouter import rerouter, config_handlers


config = """
[RESOLVER]
resolver_ip: 127.0.0.1
resolver_port: 53
tcp: True

[DOMAIN]
hostname: myself.net, myself2.net

[DNS]
srv_record: _onion-mx._tcp.

[REROUTE]
onion_transport: smtptor

[IGNORED]
domains: ignore.me, ignore2.me
"""


@pytest.fixture(scope="session", name="dummy_config")
def fixture_config():
    return config


@pytest.fixture(scope="function", name="dummy_onionrouter")
def fixture_onionrouter(monkeypatch, dummy_config):
    monkeypatch.setattr(
        config_handlers, "get_conffile",
        lambda *args, **kwargs: rerouter.OnionRouter.ref_config)
    custom_config = configparser.ConfigParser()
    custom_config._read(io.StringIO(dummy_config), None)
    monkeypatch.setattr(config_handlers, "config_reader",
                        lambda *args: custom_config)
    return rerouter.OnionRouter("nothing?")


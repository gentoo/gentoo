# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
EPYTEST_XDIST=1
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Pure Python SSH tunnels"
HOMEPAGE="https://pypi.org/project/sshtunnel/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="dev-python/paramiko[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/paramiko[server(+),${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/sshtunnel-0.4.0-dont-deadlock-tests.patch
	"${FILESDIR}"/sshtunnel-0.4.0-paramiko-4-compat.patch
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# network-sandbox
	tests/test_forwarder.py::SSHClientTest::test_gateway_ip_unresolvable_raises_exception
)

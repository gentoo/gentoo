# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Linux Landlock security module"
HOMEPAGE="
	https://pypi.org/project/py-landlock/
	https://github.com/SebastienWae/py-landlock
"
SRC_URI="https://github.com/SebastienWae/py-landlock/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

EPYTEST_DESELECT=(
	# tries to load an executable, with rule not aloowing libgcc.so.1
	"tests/e2e/test_filesystem_sandbox.py::TestFilesystemSandboxE2E::test_execute_allowed_succeeds"
)
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	default

	cat <<-EOF >> "${S}/pyproject.toml"
		[build-system]
		requires = ["hatchling"]
		build-backend = "hatchling.build"
	EOF
}

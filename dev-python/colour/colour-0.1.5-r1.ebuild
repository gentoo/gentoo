# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python color representations manipulation library"
HOMEPAGE="
	https://github.com/vaab/colour/
	https://pypi.org/project/colour/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests pytest

src_configure() {
	# Upstream uses dead & broken d2to1, just make a quick flit config
	# to make it work.
	cat > pyproject.toml <<-EOF
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "colour"
		version = "${PV}"
		description = "${DESCRIPTION}"
	EOF
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest --doctest-modules
}

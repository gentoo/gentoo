# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Distributed C/C++ package manager"
HOMEPAGE="https://conan.io/"
SRC_URI="https://github.com/conan-io/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/bottle-0.12.8[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/distro-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
	>=dev-python/patch-ng-1.17.4[${PYTHON_USEDEP}]
	>=dev-python/pluginbase-0.5[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.4[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.25[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.6[${PYTHON_USEDEP}]
"

# Try to fix it if you're brave enough
# Conan requires noumerous external toolchain dependencies with restricted
# versions and cannot be managable outside of a pure CI environment.
RESTRICT="test"

src_prepare() {
	default
	# Fix strict dependencies
	sed -i \
		-e 's:,[[:space:]]\?<=\?[[:space:]]\?[[:digit:]|.]*::g' \
		-e 's:==:>=:g' \
		conans/requirements{,_server}.txt || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Distributed C/C++ package manager"
HOMEPAGE="https://conan.io/"
SRC_URI="https://github.com/conan-io/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# overly strict requirements?
# https://github.com/conan-io/conan/blob/develop/conans/requirements.txt
# https://github.com/conan-io/conan/blob/develop/conans/requirements_server.txt
RDEPEND="
	>=dev-python/bottle-0.12.8[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/distro-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.14.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
	>=dev-python/node-semver-0.8[${PYTHON_USEDEP}]
	>=dev-python/patch-ng-1.17.4[${PYTHON_USEDEP}]
	>=dev-python/pluginbase-0.5[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-1.4[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.25[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.28.1[${PYTHON_USEDEP}]
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

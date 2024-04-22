# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Installer for Python Build Standalone"
HOMEPAGE="
	https://pypi.org/project/pbs-installer/
	https://github.com/frostming/pbs-installer/

"
SRC_URI="https://github.com/frostming/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/zstandard[${PYTHON_USEDEP}]
"

# upstream does not provide any tests
RESTRICT=test

python_configure_all() {
	export PDM_BUILD_SCM_VERSION=${PV}
}

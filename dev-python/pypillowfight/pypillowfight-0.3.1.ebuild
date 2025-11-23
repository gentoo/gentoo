# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=libpillowfight-${PV}
DESCRIPTION="Small library containing various image processing algorithms"
HOMEPAGE="
	https://gitlab.gnome.org/World/OpenPaperwork/libpillowfight/
	https://pypi.org/project/pypillowfight/
"
SRC_URI="
	https://gitlab.gnome.org/World/OpenPaperwork/libpillowfight/-/archive/${PV}/${MY_P}.tar.bz2
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e "/'nose>=1.0'/d" -i setup.py || die
	cat > src/pillowfight/_version.h <<- EOF || die
		#define INTERNAL_PILLOWFIGHT_VERSION "$(ver_cut 1-3)"
	EOF
	distutils-r1_python_prepare_all
}

python_test() {
	epytest tests -o addopts=
}

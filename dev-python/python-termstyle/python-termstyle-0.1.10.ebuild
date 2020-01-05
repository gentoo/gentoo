# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="console colouring for python"
HOMEPAGE="http://gfxmonk.net/dist/0install/python-termstyle.xml"
SRC_URI="https://github.com/gfxmonk/${PN#*-}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/termstyle-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/tests-unicode.patch
	)

	distutils-r1_python_prepare_all
}

python_test() {
	if [[ "${EPYTHON}" = "python2.7" ]]; then
		"${PYTHON}" test2.py || die "test2.py failed under ${EPYTHON}"
	else
		"${PYTHON}" test3.py || die "test3.py failed under ${EPYTHON}"
	fi
}

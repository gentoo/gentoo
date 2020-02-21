# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="pyasn1 modules"
HOMEPAGE="http://pyasn1.sourceforge.net/ https://pypi.org/project/pyasn1-modules/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-python/pyasn1-0.1.8[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	echoit() { echo "$@"; "$@"; }
	local exit_status=0 test
	cd tools || die
	for test in ../test/*.sh; do
		echoit sh "${test}" || exit_status=1
	done
	return ${exit_status}
}

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/${P}
	doins -r tools
}

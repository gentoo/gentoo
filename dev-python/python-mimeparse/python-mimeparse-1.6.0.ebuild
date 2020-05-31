# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Basic functions for handling mime-types in python"
HOMEPAGE="https://github.com/dbtsai/python-mimeparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

python_test() {
	"${EPYTHON}" mimeparse_test.py -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	local pyver=$("${EPYTHON}" -c "import distutils.sysconfig; print(distutils.sysconfig.get_python_version())")
	python_export PYTHON_SITEDIR

	# Previous versions were just called 'mimeparse'
	ln -sf python_mimeparse-${PV}-py${pyver}.egg-info \
		"${D%/}${PYTHON_SITEDIR}/mimeparse-${PV}-py${pyver}.egg-info" || die "Could not create mimeparse link"
}

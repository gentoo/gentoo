# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Basic functions for handling mime-types in python"
HOMEPAGE="
	https://code.google.com/p/mimeparse
	https://github.com/dbtsai/python-mimeparse"
MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${MY_P}"

python_test() {
	"${PYTHON}" mimeparse_test.py || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	if [[ ${EPYTHON} == pypy ]]; then
		local pyver=2.7
	elif [[ ${EPYTHON} == pypy3 ]]; then
		local pyver=3.2
	else
		local pyver=${EPYTHON#python}
	fi
	python_export PYTHON_SITEDIR

	# Previous versions were just called 'mimeparse'
	cp "${D%/}${PYTHON_SITEDIR}/python_mimeparse-${PV}-py${pyver}.egg-info" \
		"${D%/}${PYTHON_SITEDIR}/mimeparse-${PV}-py${pyver}.egg-info" || die
}

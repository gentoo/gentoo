# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mimeparse/mimeparse-0.1.4-r1.ebuild,v 1.26 2015/04/08 08:05:11 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Basic functions for handling mime-types in python"
HOMEPAGE="http://code.google.com/p/mimeparse
	https://github.com/dbtsai/python-mimeparse"
MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${MY_P}"

python_test() {
	"${PYTHON}" mimeparse_test.py || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	if [[ ${EPYTHON} == pypy* ]]; then
		local pyver=2.7
	else
		local pyver=${EPYTHON#python}
	fi
	python_export PYTHON_SITEDIR

	# Previous versions were just called 'mimeparse'
	cp "${D%/}${PYTHON_SITEDIR}/python_mimeparse-${PV}-py${pyver}.egg-info" \
		"${D%/}${PYTHON_SITEDIR}/mimeparse-${PV}-py${pyver}.egg-info" || die
}

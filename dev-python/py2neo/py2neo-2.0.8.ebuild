# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy pypy3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A simple and pragmatic library which accesses the Neo4j graph database"
HOMEPAGE="http://py2neo.org"
SRC_URI="https://github.com/nigelsmall/py2neo/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

python_compile() {
	# https://github.com/nigelsmall/py2neo/issues/380
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

#DEPEND="doc? ( dev-python/sphinx )"
#src_compile() {
#	distutils-r1_src_compile
#
#	use doc && emake -C book html
#}

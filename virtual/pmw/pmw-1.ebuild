# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/pmw/pmw-1.ebuild,v 1.7 2015/05/26 14:05:27 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit python-r1

DESCRIPTION="A virtual for pmw, for Python 2 & 3"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep 'dev-python/pmw:py2[${PYTHON_USEDEP}]' python2*)
	$(python_gen_cond_dep 'dev-python/pmw:py3[${PYTHON_USEDEP}]' python3*)"

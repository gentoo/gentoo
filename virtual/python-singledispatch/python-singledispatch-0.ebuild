# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/python-singledispatch/python-singledispatch-0.ebuild,v 1.4 2015/04/19 09:43:26 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit python-r1

DESCRIPTION="A virtual for the Python functools.singledispatch module"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="$(python_gen_cond_dep 'dev-python/singledispatch[${PYTHON_USEDEP}]' python2_7 python3_3)"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit python-r1

DESCRIPTION="A virtual for the Python functools.singledispatch module"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="$(python_gen_cond_dep 'dev-python/singledispatch[${PYTHON_USEDEP}]' python2_7 python3_3)"

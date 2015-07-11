# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/python-futures/python-futures-0.ebuild,v 1.8 2015/07/11 06:31:29 maekke Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
inherit python-r1

DESCRIPTION="A virtual for the Python concurrent.futures module"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/futures[${PYTHON_USEDEP}]' python2_7 pypy)"

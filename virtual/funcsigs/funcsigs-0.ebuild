# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/funcsigs/funcsigs-0.ebuild,v 1.2 2014/06/04 09:36:38 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{3,4}} )

inherit python-r1

DESCRIPTION="A Virtual for Python function signatures from PEP362"
HOMEPAGE=""
SRC_URI=""

SLOT="0"
LICENSE=""
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/funcsigs' python2_7)"

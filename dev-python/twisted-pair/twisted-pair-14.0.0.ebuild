# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="Twisted low-level networking"

KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="=dev-python/twisted-core-${TWISTED_RELEASE}*[${PYTHON_USEDEP}]
	dev-python/eunuchs[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# https://twistedmatrix.com/trac/ticket/7433
PATCHES=( "${FILESDIR}"/${PV}-tests.patch )

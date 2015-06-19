# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-pair/twisted-pair-14.0.0.ebuild,v 1.3 2015/04/08 08:04:52 mgorny Exp $

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

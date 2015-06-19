# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/sync2cd/sync2cd-1.3-r1.ebuild,v 1.1 2014/12/26 22:06:35 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="An incremental archiving tool to CD/DVD"
HOMEPAGE="http://www.calins.ch/software/sync2cd.html"
SRC_URI="http://www.calins.ch/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cdr dvdr"

RDEPEND="virtual/eject
	cdr? ( virtual/cdrtools )
	dvdr? ( app-cdr/dvd+rw-tools )"
DEPEND=""

python_test() {
	cd tests || die
	"${PYTHON}" run.py || die "Unit tests failed for ${EPYTHON}"
}

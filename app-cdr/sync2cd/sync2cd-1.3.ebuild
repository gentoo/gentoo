# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/sync2cd/sync2cd-1.3.ebuild,v 1.7 2014/08/10 02:14:17 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="An incremental archiving tool to CD/DVD"
HOMEPAGE="http://www.calins.ch/software/sync2cd.html"
SRC_URI="http://www.calins.ch/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="cdr dvdr"

RDEPEND="virtual/eject
	cdr? ( virtual/cdrtools )
	dvdr? ( app-cdr/dvd+rw-tools )"
DEPEND=""

PYTHON_MODNAME="sync2cd.py"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_test() {
	cd tests
	"$(PYTHON)" run.py || die "Unit tests failed"
}

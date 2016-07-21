# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic python

DESCRIPTION="library for Irman control of Unix software"
HOMEPAGE="http://iguanaworks.net/index.php"
SRC_URI="http://iguanaworks.net/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="dev-libs/popt
	virtual/libusb:0"
DEPEND="${RDEPEND}
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 )"

pkg_setup() {
	append-flags -fPIC

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i -e 's:CFLAGS =:CFLAGS ?=:' Makefile.in || die

	epatch \
		"${FILESDIR}"/${P}-gentoo.diff \
		"${FILESDIR}"/${P}-asneeded.patch
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/40-iguanaIR.rules
}

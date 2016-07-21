# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit python user

DESCRIPTION="library for Irman control of Unix software"
HOMEPAGE="http://iguanaworks.net/index.php"
SRC_URI="http://iguanaworks.net/downloads/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

# sys-apps/lsb-release is used by the init script for detecting Gentoo
RDEPEND="dev-libs/popt
	sys-apps/lsb-release
	virtual/libusb:0"
DEPEND="${RDEPEND}
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 )
	>=dev-lang/swig-2.0.0"

pkg_setup() {
	enewgroup iguanair
	enewuser iguanair -1 -1 -1 'iguanair,usb'

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Working around bug in SWIG version checking
	sed -i -e 's:1.3.31:2.0.0:g' configure || die
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS README.txt WHY notes.txt protocols.txt

	rm -f docs/{Makefile,pullDocs}
	dodoc -r docs
}

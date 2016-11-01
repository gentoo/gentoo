# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 user

DESCRIPTION="library for Irman control of Unix software"
HOMEPAGE="http://iguanaworks.net/index.php"
SRC_URI="http://iguanaworks.net/downloads/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

# sys-apps/lsb-release is used by the init script for detecting Gentoo
RDEPEND="dev-libs/popt
	sys-apps/lsb-release
	virtual/libusb:0
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2.0.0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	enewgroup iguanair
	enewuser iguanair -1 -1 -1 'iguanair,usb'

	python-single-r1_pkg_setup
}

src_prepare() {
	default
	# Working around bug in SWIG version checking
	sed -i -e 's:1.3.31:2.0.0:g' configure || die
}

src_install() {
	default
	python_optimize

	dodoc WHY notes.txt protocols.txt

	rm -f docs/{Makefile,pullDocs} || die
	dodoc -r docs
}

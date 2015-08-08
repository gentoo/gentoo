# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="2"

inherit python

DESCRIPTION="A tool for signing and email all UIDs on a set of PGP keys"
HOMEPAGE="http://www.phildev.net/pius/"
SRC_URI="mirror://sourceforge/pgpius/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-crypt/gnupg"
RDEPEND="${DEPEND}
	dev-lang/perl"

src_prepare() {
	python_convert_shebangs 2 ${PN} ${PN}-keyring-mgr
}

src_install() {
	dobin ${PN} ${PN}-keyring-mgr ${PN}-party-worksheet
	dodoc Changelog README README.keyring-mgr
}

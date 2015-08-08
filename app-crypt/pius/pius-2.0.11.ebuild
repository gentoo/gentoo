# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="A tool for signing and email all UIDs on a set of PGP keys"
HOMEPAGE="http://www.phildev.net/pius/"
SRC_URI="mirror://sourceforge/pgpius/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-crypt/gnupg
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-lang/perl"

src_install() {
	python_foreach_impl python_doscript ${PN} ${PN}-keyring-mgr
	dobin ${PN}-party-worksheet
	dodoc Changelog README README.keyring-mgr
}

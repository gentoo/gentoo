# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="GPG keyring maintenance using changesets"
HOMEPAGE="http://joeyh.name/code/jetring/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-crypt/gnupg"
RDEPEND="
	${DEPEND}
	dev-lang/perl
	"

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.21-parallel.patch
}

src_install() {
	default

	insinto /usr/share/${PN}/
	doins -r example

	doman ${PN}*.[0-9]
}

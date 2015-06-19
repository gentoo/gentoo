# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/kstart/kstart-4.1.ebuild,v 1.3 2012/03/24 17:30:35 phajdan.jr Exp $

EAPI=4

inherit eutils

DESCRIPTION="Modified versions of kinit for refreshing kerberos tickets
automatically"
HOMEPAGE="http://www.eyrie.org/~eagle/software/kstart"
SRC_URI="http://archives.eyrie.org/software/kerberos/${P}.tar.gz"

LICENSE="|| ( MIT Stanford ISC )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="afs"

DEPEND="virtual/krb5
		afs? ( net-fs/openafs )"
RDEPEND="$DEPEND"

src_configure() {
	econf \
		--enable-reduced-depends \
		"$(use_with afs)" \
		"$(use_enable afs setpag)"
}

src_install() {
	emake DESTDIR="${D}" install
	doman k5start.1 krenew.1
	dodoc README NEWS TODO examples/*
}

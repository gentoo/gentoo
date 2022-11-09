# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Modified versions of kinit for refreshing kerberos tickets automatically"
HOMEPAGE="https://www.eyrie.org/~eagle/software/kstart/"
SRC_URI="https://archives.eyrie.org/software/kerberos/${P}.tar.gz"

LICENSE="|| ( MIT Stanford ISC )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="afs"

DEPEND="virtual/krb5
		sys-apps/keyutils
		afs? ( net-fs/openafs )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--enable-reduced-depends \
		--with-libkeyutils \
		"$(use_with afs)" \
		"$(use_enable afs setpag)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS TODO examples/*
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eet/eet-1.7.9.ebuild,v 1.2 2014/03/01 22:34:46 mgorny Exp $

EAPI="4"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="E file chunk reading/writing library"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Eet"

LICENSE="BSD-2"
IUSE="debug examples gnutls ssl static-libs test"

RDEPEND=">=dev-libs/eina-${PV}
	virtual/jpeg
	sys-libs/zlib
	gnutls? (
		net-libs/gnutls
		dev-libs/libgcrypt:0
	)
	!gnutls? ( ssl? ( dev-libs/openssl ) )"
DEPEND="${RDEPEND}
	test? (
		dev-libs/check
		dev-util/lcov
	)"

src_configure() {
	E_ECONF=(
		$(use_enable debug assert)
		$(use_enable doc)
		$(use_enable examples build-examples)
		$(use_enable examples install-examples)
		$(use_enable test tests)
	)

	if use gnutls; then
		if use ssl; then
			ewarn "You have enabled both 'ssl' and 'gnutls', so we will use"
			ewarn "gnutls and not openssl for cipher and signature support"
		fi
		E_ECONF+=(
			--enable-cipher
			--enable-signature
			--disable-openssl
			--enable-gnutls
		)
	elif use ssl; then
		E_ECONF+=(
			--enable-cipher
			--enable-signature
			--enable-openssl
			--disable-gnutls
		)
	else
		E_ECONF+=(
			--disable-cipher
			--disable-signature
			--disable-openssl
			--disable-gnutls
		)
	fi

	enlightenment_src_configure
}

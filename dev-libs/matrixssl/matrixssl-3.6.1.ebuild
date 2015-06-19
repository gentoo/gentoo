# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/matrixssl/matrixssl-3.6.1.ebuild,v 1.1 2014/04/13 11:02:29 ssuominen Exp $

EAPI=5
inherit toolchain-funcs

MY_P=${P//./-}-open

DESCRIPTION="embedded SSL implementation"
HOMEPAGE="http://www.matrixssl.org/"
SRC_URI="http://www.matrixssl.org/cgi-bin/dl.pl?agree=1&.submit=DOWNLOAD -> ${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf=(
		CC="$(tc-getCC)"
		STRIP=true
		AR="$(tc-getAR)"
		DFLAGS="${CFLAGS} -Wall"
	)

	if use static-libs; then
		emake "${myconf[@]}"
	else
		emake lib${PN}.so "${myconf[@]}"
	fi
}

src_install() {
	dolib.so libmatrixssl.so
	use static-libs && dolib.a libmatrixssl.a

	# API is exposed from matrixsslApi.h and rest is included recursively
	insinto /usr/include/matrixssl
	doins matrixssl/*.h

	local h1
	for h1 in core crypto; do
		insinto /usr/include/matrixssl/${h1}
		doins ${h1}/*.h
	done

	local h2
	for h2 in digest hardware keyformat math prng pubkey symmetric; do
		insinto /usr/include/matrixssl/crypto/${h2}
		doins crypto/${h2}/*.h
	done

	if use doc; then
		insinto /usr/share/doc/${PF}/pdf
		doins doc/*.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r apps sampleCerts
	fi

	dodoc readme.txt
}

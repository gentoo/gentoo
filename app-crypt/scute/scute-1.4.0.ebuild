# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils libtool

DESCRIPTION="A PKCS #11 module for OpenPGP smartcards"
HOMEPAGE="http://www.scute.org/"
SRC_URI="mirror://gnupg/scute/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# configure script try to check the version of gpgsm and gpg-agent when
# non-crosscompiling so we need to have them as build-time dependency as
# well as runtime.  Require a version of gnupg that is patched to have
# gpgsm-gencert.sh working (as that's what the documentation describe).
DEPEND="
	>=dev-libs/libgpg-error-1.4
	>=dev-libs/libassuan-2.0.0
	>=app-crypt/pinentry-0.7.0
	>=app-crypt/gnupg-2.0.17-r1[smartcard]"
RDEPEND="${DEPEND}"

PATCHES=(
	# We need no ABI versioning, reduce the number of symlinks installed
	"${FILESDIR}/scute-1.2.0-noversion.patch"

	# Don't build tests during src_compile.
	"${FILESDIR}/scute-1.4.0-tests.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir)/pkcs11 \
		--with-gpgsm=/usr/bin/gpgsm \
		--with-gpg-agent=/usr/bin/gpg-agent
}

src_install() {
	default
	prune_libtool_files --modules
}

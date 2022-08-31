# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A PKCS #11 module for OpenPGP smartcards"
HOMEPAGE="http://www.scute.org/"
SRC_URI="
	mirror://gnupg/scute/${P}.tar.bz2
	https://dev.gentoo.org/~soap/distfiles/${P}-manual-eps-images.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

# configure script try to check the version of gpgsm and gpg-agent when
# non-crosscompiling so we need to have them as build-time dependency as
# well as runtime.  Require a version of gnupg that is patched to have
# gpgsm-gencert.sh working (as that's what the documentation describe).
BDEPEND="
	>=app-crypt/pinentry-0.7.0
	>=app-crypt/gnupg-2.0.17-r1[smartcard]"
DEPEND="
	>=dev-libs/libgpg-error-1.4
	>=dev-libs/libassuan-2.0.0"
RDEPEND="
	${DEPEND}
	${BDEPEND}"
BDEPEND+="
	sys-apps/texinfo"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_unpack() {
	default

	# have to use pregenerated EPS files required for the texinfo documentation,
	# due to bug 664236 preventing even converting *to* eps.
	mv scute-eps/*.eps "${S}"/doc/ || die
}

src_configure() {
	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/pkcs11
}

src_install() {
	default

	# only building plugins
	find "${ED}" -name '*.la' -delete || die
}

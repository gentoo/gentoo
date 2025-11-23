# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A free, pretty much fully featured and stable TrueCrypt implementation"
HOMEPAGE="https://github.com/bwalex/tc-play"
SRC_URI="https://github.com/bwalex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnutls"

DEPEND="
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error
	sys-apps/util-linux
	sys-fs/lvm2
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		dev-libs/openssl:=
	)
"
RDEPEND="${DEPEND}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-3.3-ldflags.patch
)

src_configure() {
	local backend="openssl"
	use gnutls && local backend="gcrypt"

	EXTRA_MAKE_FLAGS=(
		PBKDF_BACKEND="${backend}"
		WARNFLAGS=""
		CC="$(tc-getCC)"
		AR="$(tc-getAR)"
		PREFIX=/usr
		LIBDIR=/usr/$(get_libdir)
	)
}

src_compile() {
	emake -f Makefile.classic \
		tcplay \
		"${EXTRA_MAKE_FLAGS[@]}"
}

src_install() {
	emake -f Makefile.classic \
		"${EXTRA_MAKE_FLAGS[@]}" \
		install_program \
		DESTDIR="${ED}"
}

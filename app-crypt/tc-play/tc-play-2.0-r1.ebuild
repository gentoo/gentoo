# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

DESCRIPTION="a free, pretty much fully featured and stable TrueCrypt implementation"
HOMEPAGE="https://github.com/bwalex/tc-play"
SRC_URI="https://github.com/bwalex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnutls"

DEPEND="
	dev-libs/libgpg-error
	sys-fs/lvm2
	sys-apps/util-linux
	dev-libs/libgcrypt:0
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		dev-libs/openssl:0=
	)"
RDEPEND="${DEPEND}"

DOCS=(
	README.md
)

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

pkg_setup() {
	local backend="openssl"
	use gnutls && local backend="gcrypt"

	EXTRA_MAKE_FLAGS=(
		PBKDF_BACKEND="${backend}"
		WARNFLAGS=""
		CC=$(tc-getCC)
		AR=$(tc-getAR)
		PREFIX=/usr \
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

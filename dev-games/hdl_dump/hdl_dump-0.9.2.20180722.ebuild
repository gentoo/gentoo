# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

COMMIT="67e66ca0e0a0000563f75c573a046cb8614745ad"
DESCRIPTION="Game installer for PlayStation 2 HD Loader and Open PS2 Loader"
HOMEPAGE="https://github.com/AKuHAK/hdl-dump"
SRC_URI="https://github.com/AKuHAK/hdl-dump/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

S="${WORKDIR}/${PN//_/-}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/Makefile.patch
	# bug 906364
	"${FILESDIR}"/${PN}-0.9.2-musl-1.2.4-fix.patch
)

src_prepare() {
	default

	# Be more verbose. Patching this would be messy.
	sed -i -r "s/^(\s+)@/\1/" Makefile || die
}

src_compile() {
	# bug 906364
	append-cflags "-D_FILE_OFFSET_BITS=64"

	emake \
		CC="$(tc-getCC)" \
		RELEASE=$(usex debug no yes) \
		IIN_OPTICAL_MMAP=yes
}

src_install() {
	dobin hdl_dump
	dodoc AUTHORS CHANGELOG README.md
}

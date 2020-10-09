# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,x32,64} )

inherit flag-o-matic multilib-build toolchain-funcs

DESCRIPTION="Statifier is a tool for creating portable, self-containing Linux executables"
HOMEPAGE="http://statifier.sourceforge.net"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="
	app-shells/bash
	sys-apps/coreutils
	virtual/awk
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.4-clang.patch
	"${FILESDIR}"/${PN}-1.7.4-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.7.4-musl.patch
)

src_prepare() {
	default

	# Don't compile 32-bit on amd64 no-multilib profile
	if ! use abi_x86_32; then
		sed -e 's/ELF32 .*/ELF32 := no/g' -i configs/config.x86_64 || die
	fi
}

src_configure() {
	tc-export CC

	# Debug flags are known to cause compile failure
	filter-flags "-g*"

	# Fix permissions, as configure is not marked executable
	chmod +x configure || die
	econf
}

src_compile() {
	# Package complains with MAKEOPTS > -j1
	emake -j1
}

src_install() {
	# Package complains with MAKEOPTS > -j1
	emake -j1 DESTDIR="${ED}" install

	einstalldocs
}

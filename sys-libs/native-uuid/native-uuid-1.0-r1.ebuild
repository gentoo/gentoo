# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=".pc file for uuid"
HOMEPAGE="https://prefix.gentoo.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64-macos ~x64-macos"

DEPEND="!!sys-libs/libuuid
	!!sys-apps/util-linux"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir -p "${S}" || die
}

src_install() {
	mkdir -p "${ED}"/usr/lib/pkgconfig || die
	cat > "${ED}"/usr/lib/pkgconfig/uuid.pc <<- EOPC
		prefix=${EPREFIX}/usr
		exec_prefix=\${prefix}
		libdir=${EPREFIX}/usr/lib
		includedir=\${prefix}/include

		Name: uuid
		Description: Universally unique id library
		Version: ${PV}
		Requires:
		Cflags:
		Libs:
	EOPC
}

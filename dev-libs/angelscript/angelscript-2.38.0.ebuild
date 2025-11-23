# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A flexible, cross-platform scripting library"
HOMEPAGE="https://www.angelcode.com/angelscript/"
SRC_URI="https://www.angelcode.com/angelscript/sdk/files/angelscript_${PV}.zip"
S="${WORKDIR}/sdk"
LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc static-libs"

BDEPEND="app-arch/unzip"

pkg_setup() {
	tc-export CXX AR RANLIB
}

src_compile() {
	emake -C ${PN}/projects/gnuc shared \
		  $(use static-libs && echo static)
}

src_install() {
	emake -C ${PN}/projects/gnuc \
		  DESTDIR="${D}" \
		  PREFIX="${EPREFIX}"/usr \
		  LIBDIR_DEST='$(PREFIX)'/$(get_libdir) \
		  install_header install_shared \
		  $(use static-libs && echo install_static)

	if use doc; then
		docinto html
		dodoc -r docs/*
	fi
}

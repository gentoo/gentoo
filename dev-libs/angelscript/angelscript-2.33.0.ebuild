# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

DESCRIPTION="A flexible, cross-platform scripting library"
HOMEPAGE="http://www.angelcode.com/angelscript/"
SRC_URI="http://www.angelcode.com/angelscript/sdk/files/angelscript_${PV}.zip"
LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/sdk"

pkg_setup() {
	tc-export CXX AR RANLIB
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake -C ${PN}/projects/gnuc shared \
		  $(use static-libs && echo static)
}

multilib_src_install() {
	emake -C ${PN}/projects/gnuc \
		  DESTDIR="${D%/}" \
		  PREFIX="${EPREFIX}"/usr \
		  LIBDIR_DEST='$(PREFIX)'/$(get_libdir) \
		  install_header install_shared \
		  $(use static-libs && echo install_static)
}

multilib_src_install_all() {
	if use doc; then
		docinto html
		dodoc -r docs/*
	fi
}

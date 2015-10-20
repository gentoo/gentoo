# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs multilib-minimal

DESCRIPTION="A flexible, cross-platform scripting library"
HOMEPAGE="http://www.angelcode.com/angelscript/"
SRC_URI="http://www.angelcode.com/angelscript/sdk/files/angelscript_${PV}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

DEPEND="app-arch/unzip"

S=${WORKDIR}/sdk

pkg_setup() {
	tc-export CXX AR RANLIB
}

src_prepare() {
	multilib_copy_sources
}

multilib_src_compile() {
	emake -C ${PN}/projects/gnuc LIBRARYDEST=
}

multilib_src_install() {
	emake -C ${PN}/projects/gnuc LIBRARYDEST="${D}"/usr/$(get_libdir)/ INCLUDEDEST="${D}"/usr/include/ install
	use static-libs || { rm "${D}"/usr/$(get_libdir)/libangelscript.a || die ; }
}

multilib_src_install_all() {
	use doc && dohtml -r "${WORKDIR}"/sdk/docs/*
}

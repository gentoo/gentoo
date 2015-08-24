# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit readme.gentoo scons-utils toolchain-funcs

DESCRIPTION="The SunPinyin IMEngine Wrapper for XIM Framework"
HOMEPAGE="https://sunpinyin.googlecode.com/"
SRC_URI="https://dev.gentoo.org/~yngwin/distfiles/sunpinyin-${PV}.tar.xz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~app-i18n/sunpinyin-${PV}:=
	x11-libs/gtk+:2
	x11-libs/libX11"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	mv "${WORKDIR}/sunpinyin-${PV}" "${S}" || die
}

src_configure() {
	tc-export CXX
	myesconsargs=( --prefix="${EPREFIX}/usr" )
}

src_compile() {
	pushd "${S}"/wrapper/xim
	escons
	popd
}

src_install() {
	pushd "${S}"/wrapper/xim
	escons --install-sandbox="${D}" install
	popd
	readme.gentoo_create_doc
}

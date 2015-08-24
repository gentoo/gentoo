# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_DEPEND="2:2.5"
inherit python scons-utils toolchain-funcs

DESCRIPTION="The SunPinYin IMEngine for IBus Framework"
HOMEPAGE="https://sunpinyin.googlecode.com/"
SRC_URI="https://dev.gentoo.org/~yngwin/distfiles/sunpinyin-${PV}.tar.xz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nls"

RDEPEND="app-i18n/ibus
	~app-i18n/sunpinyin-${PV}:=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	default
	mv "${WORKDIR}/sunpinyin-${PV}" "${S}" || die
}

src_configure() {
	tc-export CXX
	myesconsargs=(
		--prefix="${EPREFIX}"/usr
		--libexecdir="${EPREFIX}"/usr/libexec
	)
}

src_compile() {
	pushd "${S}"/wrapper/ibus
	escons
	popd
}

src_install() {
	pushd "${S}"/wrapper/ibus
	escons --install-sandbox="${ED}" install
	popd
}

pkg_postinst() {
	python_mod_optimize /usr/share/ibus-sunpinyin/setup
}

pkg_postrm() {
	python_mod_cleanup /usr/share/ibus-sunpinyin/setup
}

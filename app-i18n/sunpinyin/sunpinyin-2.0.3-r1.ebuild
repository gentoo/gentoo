# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/sunpinyin/sunpinyin-2.0.3-r1.ebuild,v 1.5 2015/04/19 11:33:18 blueness Exp $

EAPI="3"

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="SunPinyin is a SLM (Statistical Language Model) based IME"
HOMEPAGE="http://sunpinyin.googlecode.com"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz
		http://open-gram.googlecode.com/files/dict.utf8.tar.bz2
		http://open-gram.googlecode.com/files/lm_sc.t3g.arpa.tar.bz2"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_unpack() {
	unpack "${P}.tar.gz"
	ln -s "${DISTDIR}/dict.utf8.tar.bz2" "${S}/raw/" || die "dict file not found"
	ln -s "${DISTDIR}/lm_sc.t3g.arpa.tar.bz2" "${S}/raw/" || die "dict file not found"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-force-switch.patch"
	epatch "${FILESDIR}/${P}-gcc-4.7.patch"
}

src_configure() {
	tc-export CXX
	myesconsargs=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--libdatadir="${EPREFIX}"/usr/lib
	)
}

src_compile() {
	escons || die
}

src_install() {
	escons --install-sandbox="${ED}" install || die
}

pkg_postinst() {
	elog ""
	elog "If you have already installed former version of ${PN}"
	elog "and any wrapper, please remerge the wrapper to make it work with"
	elog "the new version."
	elog ""
	elog "To use any wrapper for ${PN}, please merge any of the following"
	elog "packages: "
	elog "emerge app-i18n/fcitx-sunpinyin"
	elog "emerge app-i18n/ibus-sunpinyin"
	elog "emerge app-i18n/scim-sunpinyin"
	elog "emerge app-i18n/xsunpinyin"
	elog ""
}

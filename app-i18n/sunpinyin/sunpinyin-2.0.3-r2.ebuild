# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="A Statistical Language Model based Chinese input method library"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz
		https://open-gram.googlecode.com/files/dict.utf8.tar.bz2
		https://open-gram.googlecode.com/files/lm_sc.t3g.arpa.tar.bz2"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-force-switch.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
)

src_unpack() {
	unpack ${P}.tar.gz
	ln -s "${DISTDIR}"/dict.utf8.tar.bz2 "${S}"/raw/ || die "dict file not found"
	ln -s "${DISTDIR}"/lm_sc.t3g.arpa.tar.bz2 "${S}"/raw/ || die "dict file not found"
}

src_prepare() {
	default
	tc-export CXX
}

src_compile() {
	escons \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--libdatadir="${EPREFIX}"/usr/lib
}

src_install() {
	escons --install-sandbox="${D}" install
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

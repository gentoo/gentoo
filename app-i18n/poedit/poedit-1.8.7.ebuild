# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WX_GTK_VER=3.0-gtk3

PLOCALES="af am an ar ast az be be@latin bg bn br bs ca ca@valencia ckb co cs da de el en_GB eo es et eu fa fi fr fur fy_NL ga gl he hi hr hu hy id is it ja ka kab kk ko ky lt lv mk mn mr ms nb ne nl nn oc pa pl pt_BR pt_PT ro ru sk sl sq sr sv ta tg th tr tt ug uk ur uz vi wa zh_CN zh_TW"

inherit fdo-mime l10n wxwidgets

DESCRIPTION="GUI editor for gettext translations files"
HOMEPAGE="https://poedit.net"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}-oss/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

# db/expat req for legacytm (backwards support for pre 1.6)
# we currently have 1.5.5 in stable so this is enabled
RDEPEND="
	app-text/gtkspell:3
	dev-cpp/lucene++
	dev-libs/boost:=[nls]
	dev-libs/expat
	dev-libs/icu:=
	||	(
		=sys-libs/db-5*[cxx]
		=sys-libs/db-4*[cxx]
		)
	<sys-libs/db-6:=[cxx]
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	my_rm_loc() {
		sed -i -e "/^POEDIT_LINGUAS = /s: ${1}::" locales/Makefile.in || die
		rm "locales/${1}.mo" || die
	}
	l10n_find_plocales_changes 'locales' '' '.mo'
	l10n_for_each_disabled_locale_do my_rm_loc

	setup-wxwidgets
	default
}

src_configure() {
	econf --without-cpprest --without-cld2
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}

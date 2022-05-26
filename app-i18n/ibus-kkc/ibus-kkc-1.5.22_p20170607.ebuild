# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools vala vcs-snapshot

EGIT_COMMIT="f7516ae20cb648cd8b0904aec5853d3a3d2611c4"

DESCRIPTION="Japanese Kana Kanji conversion engine for IBus"
HOMEPAGE="https://github.com/ueno/ibus-kkc"
SRC_URI="https://github.com/ueno/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="app-i18n/ibus
	app-i18n/libkkc
	x11-libs/gtk+:3
	nls? ( virtual/libintl )"
RDEPEND="${DEPEND}
	app-i18n/skk-jisyo"
BDEPEND="$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	vala_src_prepare
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

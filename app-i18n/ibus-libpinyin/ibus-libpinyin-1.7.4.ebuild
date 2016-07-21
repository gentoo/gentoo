# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils python-single-r1

DESCRIPTION="ibus-libpinyin - pinyin chinese input for ibus using libpinyin"
HOMEPAGE="https://github.com/libpinyin/ibus-libpinyin"

SRC_URI="https://github.com/libpinyin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost opencc lua"

DEPEND="sys-apps/sed"
RDEPEND=">=app-i18n/ibus-1.5.4[python,${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	>=app-i18n/libpinyin-1.2.91
	app-i18n/pyzy
	boost? ( >=dev-libs/boost-1.39 )
	opencc? ( >=app-i18n/opencc-1.0.0 )
	lua? ( >=dev-lang/lua-5.1 )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	sed -i -e "s/python/${EPYTHON}/" setup/ibus-setup-libpinyin.in || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable boost )
		$(use_enable opencc )
		$(use_enable lua lua-extension )
		--enable-english-input-mode
	)
	autotools-utils_src_configure
}

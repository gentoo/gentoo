# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
PYTHON_REQ_USE="sqlite(+)"

inherit autotools gnome2-utils python-single-r1

DESCRIPTION="Intelligent Pinyin engine based on libpinyin for IBus"
HOMEPAGE="https://github.com/libpinyin/ibus-libpinyin"
SRC_URI="https://github.com/libpinyin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="boost lua opencc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-i18n/ibus[python(+),${PYTHON_USEDEP}]
	>=app-i18n/libpinyin-2.1.0:=
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	boost? ( dev-libs/boost:= )
	lua? ( dev-lang/lua:0 )
	opencc? ( app-i18n/opencc:= )"

DEPEND="${RDEPEND}
	virtual/libintl
	virtual/pkgconfig"

src_prepare() {
	default
	sed -i "s/python/${EPYTHON}/" setup/ibus-setup-libpinyin.in || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-english-input-mode \
		$(use_enable boost) \
		$(use_enable lua lua-extension) \
		$(use_enable opencc)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

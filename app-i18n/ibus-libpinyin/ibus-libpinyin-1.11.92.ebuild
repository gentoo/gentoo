# Copyright 2015-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit autotools gnome2-utils python-single-r1

DESCRIPTION="Intelligent Pinyin and Bopomofo input methods based on LibPinyin for IBus"
HOMEPAGE="https://github.com/libpinyin/ibus-libpinyin https://sourceforge.net/projects/libpinyin/"
SRC_URI="https://github.com/libpinyin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost lua opencc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="dev-db/sqlite:3
	virtual/pkgconfig"

DEPEND="${PYTHON_DEPS}
	>=app-i18n/libpinyin-2.1.0:=
	dev-db/sqlite:3
	dev-libs/glib:2
	virtual/libintl
	$(python_gen_cond_dep '
		app-i18n/ibus[python(+),${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
	boost? ( dev-libs/boost:= )
	lua? ( dev-lang/lua:0 )
	opencc? ( app-i18n/opencc:= )"

RDEPEND="${DEPEND}"

src_prepare() {
	default
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
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_6} )
PYTHON_REQ_USE="sqlite(+)"

inherit autotools gnome2-utils python-single-r1

BOOST_M4_GIT_VERSION=282b1e01f5bc5ae94347474fd8c35cb2f7a7e65d

DESCRIPTION="Intelligent Pinyin and Bopomofo input methods based on LibPinyin for IBus"
HOMEPAGE="https://github.com/libpinyin/ibus-libpinyin https://sourceforge.net/projects/libpinyin/"
SRC_URI="https://github.com/libpinyin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	boost? ( https://github.com/tsuna/boost.m4/raw/${BOOST_M4_GIT_VERSION}/build-aux/boost.m4 -> boost.${BOOST_M4_GIT_VERSION}.m4 )
"

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
	if use boost; then
		cp "${DISTDIR}/boost.${BOOST_M4_GIT_VERSION}.m4" "m4/boost.m4" \
			|| die "copying newer version of boost.m4 file failed"
	fi
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

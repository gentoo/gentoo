# Copyright 2008-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua5-1 )
PYTHON_COMPAT=( python3_{10..12} )

inherit autotools lua-single python-single-r1

DESCRIPTION="Chinese Pinyin and Bopomofo engines for IBus"
HOMEPAGE="https://github.com/ibus/ibus-pinyin"
SRC_URI="https://github.com/ibus/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost lua nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	lua? ( ${LUA_REQUIRED_USE} )"

RDEPEND="${PYTHON_DEPS}
	app-i18n/pyzy
	dev-db/sqlite:3
	$(python_gen_cond_dep '
		app-i18n/ibus[python(+),${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	boost? ( dev-libs/boost )
	lua? ( ${LUA_DEPS} )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	dev-build/autoconf-archive
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python-single-r1_pkg_setup

	if use lua; then
		lua-single_pkg_setup
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable lua lua-extension) \
		$(use_enable nls)
}

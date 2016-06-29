# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic python-single-r1

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
	boost? ( >=dev-libs/boost-1.61.0-r100:= )
	opencc? ( >=app-i18n/opencc-1.0.0 )
	lua? ( >=dev-lang/lua-5.1 )"

src_prepare() {
	default
	sed -i -e "s/python/${EPYTHON}/" setup/ibus-setup-libpinyin.in || die

	eautoreconf
}

src_configure() {
	# build with C++11 due to dev-libs/boost ABI switch. Do _NOT_
	# remove this, unless the build system enables C++11 by itself.
	append-cxxflags -std=c++11

	econf \
		$(use_enable boost ) \
		$(use_enable opencc ) \
		$(use_enable lua lua-extension ) \
		--enable-english-input-mode
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="sqlite"

inherit python

PYDB_TAR="pinyin-database-1.2.99.tar.bz2"
DESCRIPTION="Chinese PinYin IMEngine for IBus Framework"
HOMEPAGE="https://code.google.com/p/ibus/"
SRC_URI="https://ibus.googlecode.com/files/${P}.tar.gz
	https://ibus.googlecode.com/files/${PYDB_TAR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost lua nls opencc"

RDEPEND=">=app-i18n/ibus-1.4
	sys-apps/util-linux
	boost? ( >=dev-libs/boost-1.39 )
	lua? (
		>=dev-lang/lua-5.1
		<dev-lang/lua-5.2.0
	)
	nls? ( virtual/libintl )
	opencc? ( app-i18n/opencc )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	cp "${DISTDIR}"/${PYDB_TAR} data/db/open-phrase/ || die
	>py-compile
}

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable lua lua-extension) \
		$(use_enable nls) \
		$(use_enable opencc) \
		--enable-db-open-phrase
		#--disable-db-android \
		#--disable-english-input-mode \
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}

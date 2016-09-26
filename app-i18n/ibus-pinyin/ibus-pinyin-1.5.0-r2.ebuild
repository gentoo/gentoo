# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 eutils

DESCRIPTION="Chinese PinYin IMEngine for IBus Framework"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="boost lua nls"

RDEPEND="${PYTHON_DEPS}
	>=app-i18n/ibus-1.4[python,${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	app-i18n/pyzy
	boost? ( >=dev-libs/boost-1.39 )
	lua? (
		>=dev-lang/lua-5.1
		<dev-lang/lua-5.2 )
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	sys-apps/sed
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	sed -i -e "s/python/${EPYTHON}/" setup/ibus-setup-pinyin.in || die
	epatch "${FILESDIR}"/${P}-content-type-method.patch
}

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable lua lua-extension) \
		$(use_enable nls) \
		--enable-english-input-mode
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/pyzy/pyzy-0.1.0-r1.ebuild,v 1.2 2015/06/08 15:44:47 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils python-any-r1 autotools

PY_DATABASE=${PN}-database-1.0.0
DESCRIPTION="The Chinese PinYin and Bopomofo conversion library"
HOMEPAGE="https://github.com/pyzy/pyzy"
SRC_URI="https://pyzy.googlecode.com/files/${P}.tar.gz
	https://pyzy.googlecode.com/files/${PY_DATABASE}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost doc opencc test"

RDEPEND="dev-libs/glib:2
	dev-db/sqlite:3
	sys-apps/util-linux
	boost? ( dev-libs/boost )
	opencc? ( app-i18n/opencc )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )"

# Currently it fails to build test code
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-dont-download-dictionary-file.patch
	mv ../db ./data/db/open-phrase/ || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-db-open-phrase \
		--enable-db-android \
		$(use_enable boost) \
		$(use_enable opencc) \
		$(use_enable test tests)
}

src_install() {
	default
	use doc && dohtml -r docs/html/*
}

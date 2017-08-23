# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit autotools python-any-r1

PYZY_DB="${PN}-database-1.0.0"

DESCRIPTION="The Chinese PinYin and Bopomofo conversion library"
HOMEPAGE="https://github.com/pyzy/pyzy"
SRC_URI="https://pyzy.googlecode.com/files/${P}.tar.gz
	https://pyzy.googlecode.com/files/${PYZY_DB}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="boost doc opencc test"
# Currently it fails to build test code
RESTRICT="test"

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	sys-apps/util-linux
	boost? ( dev-libs/boost )
	opencc? ( app-i18n/opencc:= )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-db.patch
	"${FILESDIR}"/${PN}-opencc-1.0.0.patch
)

src_prepare() {
	mv "${WORKDIR}"/db data/db/open-phrase || die

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable opencc) \
		$(use_enable test tests) \
		--enable-db-open-phrase
}

src_install() {
	if use doc; then
		HTML_DOCS=( docs/html/. )
	fi

	default
}

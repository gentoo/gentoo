# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WANT_AUTOMAKE="1.11"
inherit autotools

DESCRIPTION="Command line client for ISDS"
HOMEPAGE="http://xpisar.wz.cz/shigofumi/"
if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI='https://repo.or.cz/shigofumi.git'
	inherit git-r3
else
	SRC_URI="http://xpisar.wz.cz/${PN}/dist/${P}.tar.bz2"
	KEYWORDS="~amd64 ~mips ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug doc nls xattr"

RDEPEND="
	dev-libs/confuse:0=
	dev-libs/libxml2:2
	sys-libs/readline:0=
	>=net-libs/libisds-0.7
	xattr? ( sys-apps/attr )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	[[ ${PV} = 9999* ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-fatalwarnings \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_enable nls) \
		$(use_enable xattr)
}

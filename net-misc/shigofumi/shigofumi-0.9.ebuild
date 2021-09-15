# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command line client for ISDS"
HOMEPAGE="http://xpisar.wz.cz/shigofumi/"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI='https://repo.or.cz/shigofumi.git'
	inherit autotools git-r3
else
	SRC_URI="http://xpisar.wz.cz/${PN}/dist/${P}.tar.bz2"
	KEYWORDS="~amd64 ~mips ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug nls xattr"

RDEPEND="
	dev-libs/confuse:=
	dev-libs/libxml2:2
	net-libs/libisds
	sys-apps/file
	sys-libs/readline:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

[[ ${PV} == *9999 ]] && BDEPEND+="
	app-text/docbook-xsl-stylesheets
	app-text/po4a
	dev-libs/libxslt"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-fatalwarnings
		--enable-doc
		--without-docbook-xsl-stylesheets
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable xattr)
	)
	[[ ${PV} == *9999 ]] && myeconfargs+=(
		--with-docbook-xsl-stylesheets
	)

	econf "${myeconfargs[@]}"
}

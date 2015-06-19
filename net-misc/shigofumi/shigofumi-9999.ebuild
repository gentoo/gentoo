# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/shigofumi/shigofumi-9999.ebuild,v 1.9 2013/01/02 17:44:19 scarabeus Exp $

EAPI=5

EGIT_REPO_URI='git://repo.or.cz/shigofumi.git'
WANT_AUTOMAKE="1.11"
inherit base
[[ ${PV} = 9999* ]] && inherit git-2 autotools

DESCRIPTION="Command line client for ISDS"
HOMEPAGE="http://xpisar.wz.cz/shigofumi/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://xpisar.wz.cz/${PN}/dist/${P}.tar.bz2"
	KEYWORDS="~amd64 ~mips ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug doc nls xattr"

RDEPEND="dev-libs/confuse
	dev-libs/libxml2
	sys-libs/readline
	>=net-libs/libisds-0.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
	nls? ( sys-devel/gettext )"

DOCS=( NEWS README AUTHORS ChangeLog )

src_prepare() {
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

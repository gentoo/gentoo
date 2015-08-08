# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="CLI and C api to get data from Bugzilla"
HOMEPAGE="https://github.com/yaccz/cbugzilla"
SRC_URI="http://dev.gentoo.org/~yac/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/curl
	dev-libs/libxdg-basedir
	app-text/htmltidy"
RDEPEND="${DEPEND}"

DOCS=( "README.rst" "ChangeLog.rst" )

src_configure() {
	econf --disable-werror
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CLI and C api to get data from Bugzilla"
HOMEPAGE="https://github.com/yaccz/cbugzilla"
SRC_URI="https://dev.gentoo.org/~yac/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-text/htmltidy
	dev-libs/libxdg-basedir
	net-misc/curl
"
RDEPEND="${DEPEND}"

DOCS=( "README.rst" "ChangeLog.rst" )

src_configure() {
	econf --disable-werror
}

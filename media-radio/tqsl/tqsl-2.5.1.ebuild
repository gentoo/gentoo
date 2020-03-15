# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils wxwidgets vcs-snapshot

DESCRIPTION="ARRL Logbook of the World"
HOMEPAGE="http://www.arrl.org/tqsl-download"
SRC_URI="https://github.com/rich0/trustedqsl-tqsl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LOTW"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/expat:=
		dev-libs/openssl:0=
		net-misc/curl:=
		sys-libs/db:=
		sys-libs/zlib:=
		x11-libs/wxGTK:3.0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.txt INSTALL README )
HTML_DOCS=( html )

WX_GTK_VER=3.0

pkg_setup() {
	setup-wxwidgets
}

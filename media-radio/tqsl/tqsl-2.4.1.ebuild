# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils wxwidgets

DESCRIPTION="ARRL Logbook of the World"
HOMEPAGE="http://www.arrl.org/tqsl-download"
SRC_URI="https://sourceforge.net/code-snapshots/git/t/tr/trustedqsl/tqsl.git/trustedqsl-tqsl-fa49d1a6a2a9c06181f72558f732e7960cb3f430.zip -> ${P}.zip"

S=${WORKDIR}/trustedqsl-tqsl-fa49d1a6a2a9c06181f72558f732e7960cb3f430/

LICENSE="LOTW"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/expat:=
		dev-libs/openssl:=
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

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="extracts URLs from correctly-encoded MIME email messages or plain text"
HOMEPAGE="https://www.memoryhole.net/~kyle/extract_url/ https://github.com/m3m0ryh0l3/extracturl/"
SRC_URI="https://github.com/m3m0ryh0l3/${PN/_/}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/MIME-tools
	dev-perl/HTML-Parser
	dev-perl/URI-Find
	dev-perl/Curses-UI
	dev-perl/TermReadKey
"

S=${WORKDIR}/${P/_/}

src_install() {
	default
	dodoc extract_urlview.sample
}

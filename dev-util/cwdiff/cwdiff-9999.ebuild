# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/junghans/${PN}.git https://github.com/junghans/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/junghans/cwdiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x64-macos ~x86-macos"
fi

DESCRIPTION="A script that wraps wdiff to support directories and colorize the output"
HOMEPAGE="https://github.com/junghans/cwdiff"

LICENSE="GPL-2"
SLOT="0"
IUSE="mercurial"

DEPEND="sys-apps/help2man
	sys-apps/coreutils"
RDEPEND="
	sys-apps/sed
	app-shells/bash
	app-text/wdiff
	sys-apps/diffutils
	mercurial? ( dev-vcs/mercurial )
	"

src_install() {
	emake DESTDIR="${ED}" $(usex mercurial '' 'HGRCDIR=') install
	dodoc README.md
}

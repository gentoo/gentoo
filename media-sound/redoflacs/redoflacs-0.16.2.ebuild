# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/redoflacs/redoflacs-0.16.2.ebuild,v 1.2 2015/03/21 18:33:50 jlec Exp $

EAPI=5

inherit vcs-snapshot

DESCRIPTION="Bash commandline flac verifier, organizer, analyzer"
HOMEPAGE="https://github.com/sirjaren/redoflacs"
SRC_URI="https://github.com/sirjaren/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-shells/bash
	media-libs/flac
	sys-apps/coreutils
	sys-apps/findutils"

src_install() {
	newbin redoFlacs redoflacs
}

pkg_postinst() {
	elog "This script makes use of optional programs if installed:"
	elog "   media-sound/sox       ->  support for creating spectrograms"
	elog "   media-libs/libpng     ->  needed by media-sound/sox"
	elog "   media-sound/aucdtect  ->  support for determining authenticity"
	elog "                             of FLAC files (CDDA)"
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/redoflacs/redoflacs-0.19.ebuild,v 1.2 2015/03/21 18:33:50 jlec Exp $

EAPI=5

inherit readme.gentoo vcs-snapshot

DESCRIPTION="Bash commandline flac compressor, verifier, organizer, analyzer, retagger"
HOMEPAGE="https://github.com/sirjaren/redoflacs"
SRC_URI="https://github.com/sirjaren/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	>=app-shells/bash-4
	media-libs/flac
	sys-apps/coreutils"

src_install() {
	dobin redoflacs
	readme.gentoo_create_doc
}

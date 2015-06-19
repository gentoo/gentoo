# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cwdiff/cwdiff-0.2.8.ebuild,v 1.1 2015/03/13 20:12:37 ottxor Exp $

EAPI=5

DESCRIPTION="A script that wraps wdiff to support directories and colorize the output"
HOMEPAGE="https://github.com/junghans/cwdiff"
SRC_URI="https://github.com/junghans/cwdiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x64-macos ~x86-macos"
IUSE="a2ps mercurial"

DEPEND=""
RDEPEND="
	sys-apps/sed
	app-shells/bash
	app-text/wdiff
	sys-apps/diffutils
	a2ps? ( app-text/a2ps )
	mercurial? ( dev-vcs/mercurial )
	"

src_install () {
	dobin "${PN}"
	if use mercurial ; then
		insinto /etc/mercurial/hgrc.d
		doins hgrc.d/"${PN}".rc
	fi
	dodoc README.md
}

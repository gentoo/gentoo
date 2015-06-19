# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-mantle/git-mantle-0.6.ebuild,v 1.1 2015/04/22 13:27:15 yac Exp $

EAPI=5

inherit eutils

DESCRIPTION="Generate an overview of changes on a branch"
HOMEPAGE="https://github.com/roman-neuhauser/git-mantle"

SRC_URI="http://codex.sigpipe.cz/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~x86 ~amd64"

DEPEND=""
RDEPEND="
	dev-vcs/git
	app-shells/zsh
"

src_install(){
	emake PREFIX="${ED}/usr" install
}

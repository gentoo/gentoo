# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-mailz/git-mailz-0.12.ebuild,v 1.1 2015/04/22 14:41:01 yac Exp $

EAPI=5

inherit eutils

DESCRIPTION="Send a collection of patches as emails"
HOMEPAGE="https://github.com/roman-neuhauser/git-mailz/"

SRC_URI="http://codex.sigpipe.cz/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~x86 ~amd64"

DEPEND=""

RDEPEND="
	virtual/mta
	dev-vcs/git
	app-shells/zsh
"

src_install(){
	emake PREFIX="${ED}/usr" install
}

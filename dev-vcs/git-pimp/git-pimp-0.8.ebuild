# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Code review or pull requests as patch email series"
HOMEPAGE="https://github.com/roman-neuhauser/git-mailz/"

SRC_URI="http://codex.sigpipe.cz/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~x86 ~amd64"

DEPEND=""

RDEPEND="
	dev-vcs/git
	app-shells/zsh
	dev-vcs/git-mailz
	dev-vcs/git-mantle
"

src_install(){
	emake PREFIX="${ED}/usr" install
}

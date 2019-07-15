# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Send a collection of patches as emails"
HOMEPAGE="https://github.com/roman-neuhauser/git-mailz/"

SRC_URI="http://codex.sigpipe.cz/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=""

RDEPEND="
	virtual/mta
	dev-vcs/git
	app-shells/zsh
"

src_install(){
	emake PREFIX="${ED}/usr" install
}

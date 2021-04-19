# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Send a collection of patches as emails"
HOMEPAGE="https://github.com/roman-neuhauser/git-mailz/"
SRC_URI="http://codex.sigpipe.cz/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-shells/zsh
	dev-vcs/git
	virtual/mta
"

src_compile() {
	emake GZIPCMD="true"
}

src_install() {
	emake PREFIX="${ED}/usr" install

	mv "${ED}"/usr/share/man/man1/git-mailz.1{.gz,} || die
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools bash-completion-r1 git-r3

DESCRIPTION="JSON output from a shell"
HOMEPAGE="https://github.com/jpmens/jo"
EGIT_REPO_URI="https://github.com/jpmens/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	export bashcompdir=$(get_bashcompdir)
	default
}

src_install() {
	default
	mv "${D}"$(get_bashcompdir)/jo{.bash,} || die
}

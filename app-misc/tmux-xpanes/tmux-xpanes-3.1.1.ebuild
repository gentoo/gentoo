# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="tmux-based terminal divider"
HOMEPAGE="https://github.com/greymd/tmux-xpanes"
SRC_URI="https://github.com/greymd/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="MIT"
SLOT="0"

IUSE="zsh-completion"

RDEPEND="
	app-misc/tmux
	dev-lang/perl
	dev-libs/openssl:0=
	zsh-completion? ( app-shells/zsh )"

DEPEND="${RDEPEND}"

RESTRICT="test"

DOCS=( CONTRIBUTING.md LICENSE README.md )

src_install() {
	dobin bin/*
	doman man/*.1
	einstalldocs
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins completion/zsh/*
	fi
}

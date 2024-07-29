# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generate an overview of changes on a branch"
HOMEPAGE="https://github.com/roman-neuhauser/git-mantle"

SRC_URI="http://codex.sigpipe.cz/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

KEYWORDS="~amd64 ~x86"

DEPEND="test? ( dev-util/cram )"
RDEPEND="
	dev-vcs/git
	app-shells/zsh
"

src_install() {
	# Don't install in /usr/local
	emake PREFIX="${ED}/usr" install
	einstalldocs
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Code review or pull requests as patch email series"
HOMEPAGE="https://github.com/roman-neuhauser/git-mailz/"

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
	dev-vcs/git-mailz
	dev-vcs/git-mantle
"

src_install(){
	# Do not install in /usr/local
	emake PREFIX="${ED}/usr" install
	einstalldocs
}

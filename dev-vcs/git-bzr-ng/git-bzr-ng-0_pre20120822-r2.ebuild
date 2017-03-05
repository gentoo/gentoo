# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Git subcommand providing a bidirectional bridge to Bazaar repositories"
HOMEPAGE="https://github.com/termie/git-bzr-ng"
SRC_URI="https://dev.gentoo.org/~tetromino/distfiles/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-vcs/bzr-2.2
	dev-vcs/git
	>=dev-vcs/bzr-fastimport-0.10
	${PYTHON_DEPS}"
DEPEND="app-arch/xz-utils"

src_prepare() {
	default
	python_fix_shebang git-bzr
}

src_install() {
	exeinto /usr/libexec/git-core
	doexe git-bzr
	dodoc README.rst
}

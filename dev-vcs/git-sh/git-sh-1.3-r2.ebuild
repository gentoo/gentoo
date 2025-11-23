# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A customized bash environment suitable for git work"
HOMEPAGE="https://github.com/rtomayko/git-sh"
SRC_URI="https://github.com/rtomayko/git-sh/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-vcs/git"

src_prepare() {
	default
	sed -e 's/git-completion\.bash //' \
		-e 's:/local::' \
		-i Makefile \
		|| die "sed failed"
}

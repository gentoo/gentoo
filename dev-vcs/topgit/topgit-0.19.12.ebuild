# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="A different patch queue manager"
HOMEPAGE="https://mackyle.github.io/topgit/topgit.html https://github.com/mackyle/topgit"
SRC_URI="https://github.com/mackyle/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="sys-apps/sed
	virtual/awk"
RDEPEND=">=dev-vcs/git-2.10.0"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/${P}-Rename-T-to-TESTSUITE.patch"
)

src_compile() {
	# Needed because of "hardcoded" paths
	emake prefix="/usr" sharedir="/usr/share/doc/${PF}"
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" sharedir="/usr/share/doc/${PF}" install

	newbashcomp contrib/tg-completion.bash tg
	dodoc README
}

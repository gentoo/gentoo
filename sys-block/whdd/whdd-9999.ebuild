# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Diagnostic and recovery tool for block devices"
HOMEPAGE="https://whdd.github.io"

inherit toolchain-funcs

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	inherit vcs-snapshot
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-util/dialog:=
	sys-libs/ncurses:=[unicode(+)]"
RDEPEND="${DEPEND}
	sys-apps/smartmontools"

src_compile() {
	tc-export CC
	default
}

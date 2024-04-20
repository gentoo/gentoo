# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/animetosho/par2cmdline-turbo"
else
	SRC_URI="https://github.com/animetosho/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="par2cmdline × ParPar: speed focused par2cmdline fork"
HOMEPAGE="https://github.com/animetosho/par2cmdline-turbo"

LICENSE="GPL-2+"
SLOT="0"
IUSE="openmp"

RDEPEND="
	!app-arch/par2cmdline
"

src_prepare() {
	default
	eautoreconf
}

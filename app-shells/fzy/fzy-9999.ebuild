# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit savedconfig toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jhawthorn/fzy.git"
else
	SRC_URI="https://github.com/jhawthorn/fzy/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Fuzzy text selector (interactive grep) for console"
HOMEPAGE="https://github.com/jhawthorn/fzy"

LICENSE="MIT"
SLOT="0"
IUSE="test"

PATCHES=( "${FILESDIR}"/fzy-0.9-cflags.patch )

src_prepare() {
	default
	restore_config config.h
	tc-export CC
}

src_install() {
	local DOCS=( ALGORITHM.md CHANGELOG.md README.md )
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	exeinto /usr/share/fzy
	doexe contrib/fzy-tmux
	doexe contrib/fzy-dvtm
	einstalldocs
	save_config config.h
}

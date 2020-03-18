# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils savedconfig toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jhawthorn/fzy.git"
else
	SRC_URI="https://github.com/jhawthorn/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Fuzzy text selector (interactive grep) for console"
HOMEPAGE="https://github.com/jhawthorn/fzy"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/fzy-0.9-cflags.patch )

src_prepare() {
	default
	restore_config config.h
	tc-export CC
}

src_install() {
	local DOCS=( ALGORITHM.md CHANGELOG.md README.md )
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dobin contrib/fzy-tmux
	dobin contrib/fzy-dvtm
	einstalldocs
	save_config config.h
}

pkg_postinst() {
	savedconfig_pkg_postinst
	optfeature "opening search results in dvtm pane with provided ${EPREFIX}/usr/bin/fzy-dvtm" app-misc/dvtm
	optfeature "opening search results in tmux pane with provided ${EPREFIX}/usr/bin/fzy-tmux" app-misc/tmux
}

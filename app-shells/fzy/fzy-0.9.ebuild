# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit savedconfig

DESCRIPTION="Fuzzy text selector (interactive grep) for console"
HOMEPAGE="https://github.com/jhawthorn/fzy"
SRC_URI="https://github.com/jhawthorn/fzy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="test"

KEYWORDS="~amd64 ~x86"

src_prepare() {
	eapply_user
	sed -i  -e '/^CFLAGS/s/ -O3//' Makefile || die "sed failed"
	restore_config config.h
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

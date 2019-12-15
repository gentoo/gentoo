# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit git-r3

DESCRIPTION="Collection of Gentoo eclass manpages"
HOMEPAGE="https://github.com/mgorny/eclass-to-manpage"
SRC_URI=""
EGIT_REPO_URI="https://anongit.gentoo.org/git/repo/gentoo.git
	https://github.com/gentoo/gentoo.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

BDEPEND="sys-apps/gawk"

src_unpack() {
	git-r3_fetch
	git-r3_fetch "https://github.com/mgorny/eclass-to-manpage"

	git-r3_checkout '' '' '' eclass
	git-r3_checkout "https://github.com/mgorny/eclass-to-manpage"
}

src_compile() {
	emake ECLASSDIR=eclass
}

src_install() {
	emake install ECLASSDIR=eclass DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
}

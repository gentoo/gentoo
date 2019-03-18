# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit git-r3

DESCRIPTION="Collection of Gentoo eclass manpages"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""
EGIT_REPO_URI="https://anongit.gentoo.org/git/repo/gentoo.git
	https://github.com/gentoo/gentoo.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' '' '' eclass
}

src_compile() {
	env ECLASSDIR="${S}/eclass" bash "${FILESDIR}"/eclass-to-manpage.sh || die
}

src_install() {
	doman *.5
}

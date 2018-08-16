# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Easy GIT (eg), a frontend for git designed for former cvs and svn users"
HOMEPAGE="https://www.gnome.org/~newren/eg/"
SRC_URI="https://www.gnome.org/~newren/eg/download/${PV}/eg -> ${P}"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""

RDEPEND=">=dev-vcs/git-${PV}
	dev-lang/perl"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${P}" eg || die
}

src_install() {
	dobin eg
}

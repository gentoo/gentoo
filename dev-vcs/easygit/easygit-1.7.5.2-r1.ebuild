# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Easy GIT (eg), a frontend for git designed for former cvs and svn users"
HOMEPAGE="https://www.gnome.org/~newren/eg/"
SRC_URI="https://www.gnome.org/~newren/eg/download/${PV}/eg -> ${P}"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-vcs/git-${PV}
	dev-lang/perl"

src_install() {
	newbin "${DISTDIR}"/${P} eg
}

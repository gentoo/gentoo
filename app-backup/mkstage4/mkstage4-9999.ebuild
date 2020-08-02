# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Bash Utility for Creating Stage 4 Tarballs"
HOMEPAGE="https://github.com/TheChymera/mkstage4"
EGIT_REPO_URI="https://github.com/TheChymera/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash
	app-arch/tar"

src_install() {
	newbin mkstage4.sh mkstage4
	einstalldocs
}

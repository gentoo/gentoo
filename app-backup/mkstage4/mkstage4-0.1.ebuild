# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Bash Utility for Creating Stage 4 Tarballs"
HOMEPAGE="https://github.com/TheChymera/mkstage4"
SRC_URI="https://github.com/TheChymera/mkstage4/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash
	app-arch/tar"

src_install() {
	newbin mkstage4.sh mkstage4
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Weather in terminal, with ANSI colors and Unicode symbols"
HOMEPAGE="https://github.com/fcambus/ansiweather/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fcambus/${PN}.git"
else
	SRC_URI="https://github.com/fcambus/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	app-misc/jq
	app-alternatives/bc
	|| ( net-misc/curl net-ftp/ftp net-misc/wget )
"

DOCS=( AUTHORS ChangeLog README.md ansiweatherrc.example )

src_install() {
	exeinto /usr/bin
	doexe ${PN}

	doman ${PN}.1

	einstalldocs
}

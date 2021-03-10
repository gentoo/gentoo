# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A terminal for a more modern age"
HOMEPAGE="https://eugeny.github.io/terminus/"
SRC_URI="https://github.com/Eugeny/terminus/releases/download/v${PV}/${P}-linux.tar.gz
https://iconarchive.com/download/i106437/papirus-team/papirus-apps/terminus.ico"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

inherit desktop xdg-utils

S=""${WORKDIR}"/"${P}"-linux"

DEPEND="net-print/cups" # Requested by electron

src_prepare(){
	default

	# Remove useless license files.
	rm -rf LICENSE.electron.txt LICENSES.electron.html || die
}

src_install(){
	insinto /opt/"${PN}"
	doins -r "${S}"/*
	dosym /opt/"${PN}"/terminus /usr/bin/terminus
	fperms +x /opt/"${PN}"/terminus
	make_desktop_entry /opt/terminus/terminus terminus
	doicon "${DISTDIR}"/terminus.ico
}

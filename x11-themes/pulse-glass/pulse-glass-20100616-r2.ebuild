# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Pulse-Glass"

DESCRIPTION="The Pulse Glass x11 mouse cursor theme"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dl.opendesktop.org/api/files/downloadfile/id/1460735439/s/bdd2fc99c6d7c6dae5a922c9ee5f688f/t/1524406902/u/54541/124442-${MY_PN}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	insinto /usr/share/icons/${MY_PN}
	doins -r cursors
}

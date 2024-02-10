# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Graphical configuration for iDesk plus icons"
HOMEPAGE="https://web.archive.org/web/20070828214007/http://www.jmurray.id.au/idesk-extras.html"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-shells/bash
	x11-misc/idesk
	x11-misc/xdialog"

PATCHES=( "${FILESDIR}"/${P}-stdout.patch )
HTML_DOCS=( ${PN}.html )

src_install() {
	dobin idesktool
	einstalldocs

	insinto /usr/share/idesk
	doins -r icons
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils git-r3

DESCRIPTION="multi-platform GUI for pass, the standard unix password manager"
HOMEPAGE="https://qtpass.org/"
EGIT_REPO_URI="https://github.com/IJHack/${PN}.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
DOCS=( FAQ.md README.md CONTRIBUTING.md )

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5[xcb]
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	app-admin/pass
	net-misc/x11-ssh-askpass"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

src_configure() {
	eqmake5 PREFIX="${D}"/usr
}

src_install() {
	default

	doman ${PN}.1

	insinto /usr/share/applications
	doins "${PN}.desktop"

	newicon artwork/icon.svg "${PN}-icon.svg"
}

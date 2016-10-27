# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="QtPass-${PV}"

inherit qmake-utils

DESCRIPTION="multi-platform GUI for pass, the standard unix password manager"
HOMEPAGE="https://qtpass.org/"
SRC_URI="https://github.com/IJHack/${PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+qt5"
DOCS=( FAQ.md README.md CONTRIBUTING.md )
S="${WORKDIR}/${MY_P}"

RDEPEND="qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[xcb]
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	app-admin/pass
	net-misc/x11-ssh-askpass"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

src_configure() {
	if use qt5 ; then
		eqmake5 PREFIX="${D}"/usr
	else
		eqmake4 PREFIX="${D}"/usr
	fi
}

src_install() {
	default

	doman ${PN}.1

	insinto /usr/share/applications
	doins "${PN}.desktop"

	newicon artwork/icon.svg "${PN}-icon.svg"
}

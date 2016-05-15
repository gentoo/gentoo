# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

DESCRIPTION="multi-platform GUI for pass, the standard unix password manager"
HOMEPAGE="https://qtpass.org/"
SRC_URI="https://github.com/IJHack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+qt5"
DOCS=( FAQ.md README.md CONTRIBUTING.md )

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
	app-admin/pass"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )"

src_prepare() {
	# Modify install path
	sed -i "s/target.path = \$\$PREFIX/target.path = \$\$PREFIX\/bin/" \
		${PN}.pro \
		|| die "sed failed to modify install path for ${PN}.pro"

	# Backport segfault fix https://github.com/IJHack/qtpass/issues/122
	# (ToDo: remove this in 1.0.6)
	sed -e "/QtPass = NULL;/{n;d};/startupPhase = true;/a autoclearTimer = NULL;" \
		-i mainwindow.cpp || die "sed failed mainwindow.cpp"

	epatch_user
}

src_configure() {
	if use qt5 ; then
		eqmake5 PREFIX="${D}"/usr
	else
		eqmake4 PREFIX="${D}"/usr
	fi
}

src_install() {
	default

	insinto /usr/share/applications
	doins "${PN}.desktop"

	newicon artwork/icon.svg "${PN}-icon.svg"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Powerful and flexible backup (and syncing) tool, using RSync and Qt"
HOMEPAGE="http://luckybackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	net-misc/rsync"

DOCS=( readme/{AUTHORS,README,TODO,TRANSLATIONS,changelog} )

src_prepare() {
	sed -i \
		-e "s:/usr/share/doc/${PN}:/usr/share/doc/${PF}:g" \
		-e "s:/usr/share/doc/packages/${PN}:/usr/share/doc/${PF}:g" \
		luckybackup.pro src/global.cpp || die "sed failed"

	# The su-to-root command is an ubuntu-specific script so it will
	# not work with Gentoo. No reason to have it anyway.
	sed -i -e "/^Exec/s:=.*:=/usr/bin/${PN}:" menu/${PN}-gnome-su.desktop \
		|| die "failed to remove su-to-root"

	# causes empty directory to be installed
	sed -i -e '/^INSTALLS/s/debianmenu //' luckybackup.pro \
		|| die "sed installs failed"

	# remove text version - cannot remote HTML version
	# as it's used within the application
	rm license/gpl.txt || die "rm failed"

	default
}

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

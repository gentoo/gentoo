# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Powerful and flexible backup (and syncing) tool, using RSync and Qt"
HOMEPAGE="https://luckybackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	net-misc/rsync
	sys-auth/polkit
"

DOCS=( readme/{AUTHORS,README,TODO,TRANSLATIONS,changelog} )

PATCHES=( "${FILESDIR}/${P}-nomancompress.patch" )

src_prepare() {
	default

	sed -i \
		-e "s:/usr/share/doc/${PN}:/usr/share/doc/${PF}:g" \
		-e "s:/usr/share/doc/packages/${PN}:/usr/share/doc/${PF}:g" \
		luckybackup.pro src/global.cpp || die "sed failed"

	# bogus dependency - bug #645732
	sed -i -e '/QT += network/s/^/#/' luckybackup.pro || die

	# remove text version - cannot remove HTML version
	# as it's used within the application
	rm license/gpl.txt || die "rm failed"
}

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

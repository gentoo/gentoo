# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

LANGS="it"
inherit bash-completion-r1 qt4-r2

DESCRIPTION="Helper to dock any application into the system tray"
HOMEPAGE="https://github.com/user-none/KDocker"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV:0:3}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsingleapplication[qt4(+),X]
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXpm
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS BUGS ChangeLog CREDITS README TODO )
PATCHES=( "${FILESDIR}/${P}-unbundle-qtsingleapplication.patch" )

src_prepare() {
	qt4-r2_src_prepare

	if ! use linguas_it ; then
		sed -e '/^INSTALLS +=/s/translations//' -i kdocker.pro || die "sed failed"
	fi

	sed -i -e "/completion.path/s%/etc/bash_completion.d%$(get_bashcompdir)%" \
		kdocker.pro || die "sed failed"
}

src_configure() {
	eqmake4 PREFIX="${EPREFIX}/usr" SYSTEMQTSA=1
}

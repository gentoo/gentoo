# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 qmake-utils

DESCRIPTION="Helper to dock any application into the system tray"
HOMEPAGE="https://github.com/user-none/KDocker"
SRC_URI="https://github.com/user-none/KDocker/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXpm
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS BUGS ChangeLog CREDITS README.md TODO )

S=${WORKDIR}/KDocker-${PV}

src_prepare() {
	default

	sed -i -e "/completion.path/s%/etc/bash_completion.d%$(get_bashcompdir)%" \
		kdocker.pro || die "sed failed"
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" SYSTEMQTSA=1
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

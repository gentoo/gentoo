# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Amateur radio logbook software"
HOMEPAGE="https://github.com/foldynl/QLog"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/foldynl/QLog.git"
else
	SRC_URI="https://github.com/foldynl/QLog/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/QLog-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/qtkeychain
	dev-qt/qtbase:6[dbus,gui,network,sql,xml]
	dev-qt/qtcharts:6
	dev-qt/qtserialport:6
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6[widgets]
	dev-qt/qtwebsockets:6
	media-libs/hamlib:=
	virtual/zlib:=
"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake6 \
		PREFIX="${PREFIX}/usr/" \
		HAMLIBINCLUDEPATH="${EPREFIX}/usr/include/hamlib" \
		HAMLIBLIBPATH="${EPREFIX}/usr/$(get_libdir)/hamlib" \
		QLog.pro
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}

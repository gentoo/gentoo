# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=783ea4e61cbfe54250e809498b1496d6cbd5afa1
inherit qmake-utils xdg-utils

DESCRIPTION="Qt5 MPD client with experimental UI"
HOMEPAGE="https://www.linux-apps.com/content/show.php/BE::MPC?content=137091"
SRC_URI="https://sourceforge.net/code-snapshots/git/b/be/be-mpc/code.git/be-mpc-code-${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libmpdclient
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-qt/qtconcurrent:5
"

src_unpack() {
	default
	mv be-mpc-code-"${COMMIT}" "${A%.zip}" || die
}

src_prepare() {
	default

	# Install on live fs should be done by portage itself
	sed -e 's/postinstall/#postinstall/g' \
		-i be.mpc.pro

	# Fix invalid desktop file
	sed -e 's/Categories=Application;Qt;Audio;/Categories=Qt;AudioVideo;Audio;/' \
		-i be.mpc.desktop

	eqmake5 be.mpc.pro
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

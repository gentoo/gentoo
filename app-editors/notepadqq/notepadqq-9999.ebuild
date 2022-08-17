# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Notepad++-like editor for Linux"
HOMEPAGE="https://notepadqq.com/s/"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/notepadqq/notepadqq.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P/_/-}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="
	app-i18n/uchardet
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
	dev-qt/qtwebsockets:5
"
BDEPEND="dev-qt/linguist-tools:5"

src_prepare() {
	default

	# Silence a QA warning
	sed '/^OnlyShowIn/d' \
		-i support_files/shortcuts/notepadqq.desktop \
		|| die
}

src_configure() {
	eqmake5 \
		LRELEASE="$(qt5_get_bindir)/lrelease" \
		QMAKE="$(qt5_get_bindir)/qmake" \
		PREFIX="${EPREFIX}/usr" \
		${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

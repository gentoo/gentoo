# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="https://www.librecad.org/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/LibreCAD/LibreCAD.git"
	inherit git-r3
else
	SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/v${PV/_/}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/LibreCAD-${PV}"
	KEYWORDS="~amd64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc tools"

RDEPEND="
	dev-cpp/muParser
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/freetype:2
"
DEPEND="${RDEPEND}
	dev-qt/qthelp:5
	dev-qt/qtxml:5
"
BDEPEND="
	dev-qt/linguist-tools:5
"

src_prepare() {
	default

	sed -e "/^LRELEASE/s:lrelease:$(qt6_get_bindir)/lrelease:" \
		-i scripts/postprocess-unix.sh || die
}

src_configure() {
	eqmake5 -r
}

src_install() {
	dobin unix/librecad
	use tools && dobin unix/ttf2lff
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && docinto html && dodoc -r librecad/support/doc/*
	insinto /usr/share/metainfo
	doins unix/appdata/org.librecad.librecad.appdata.xml
	doicon librecad/res/main/${PN}.png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=aea82babdc0e6e9dc8cc4580abe08a579aa52186
inherit desktop qmake-utils

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="https://www.librecad.org/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/LibreCAD/LibreCAD.git"
	inherit git-r3
else
	SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
	S="${WORKDIR}/LibreCAD-${COMMIT}"
	KEYWORDS="amd64 ~ppc64 ~riscv x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc tools"

RDEPEND="
	dev-cpp/muParser
	dev-libs/boost:=
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtsvg:6
	media-libs/freetype:2
"
DEPEND="${RDEPEND}
	dev-qt/qtbase:6[xml]
	dev-qt/qttools:6[assistant]
"
BDEPEND="
	dev-qt/qttools:6[linguist]
"

src_prepare() {
	default

	sed -e "/^LRELEASE/s:lrelease:$(qt6_get_bindir)/lrelease:" \
		-i scripts/postprocess-unix.sh || die
}

src_configure() {
	eqmake6 -r
}

src_install() {
	dobin unix/librecad
	use tools && dobin unix/ttf2lff
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && docinto html && dodoc -r librecad/support/doc/*
	insinto /usr/share/metainfo
	doins unix/appdata/org.librecad.librecad.appdata.xml
	doicon librecad/res/images/${PN}.png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}

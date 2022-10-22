# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop qmake-utils

MY_PV="${PV//./_}"
MY_P="${PN}_${MY_PV}"

DESCRIPTION="GPS waypoints, tracks and routes converter"
HOMEPAGE="https://www.gpsbabel.org/ https://github.com/gpsbabel/gpsbabel"

if [[ ${PV} == 9999 ]] ; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/gpsbabel/gpsbabel.git"
        SRC_URI="doc? ( https://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )"
else
        SRC_URI="
                https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_${MY_PV}.tar.gz
                doc? ( https://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )
        "
        KEYWORDS="amd64 ~ppc x86"
        S="${WORKDIR}/gpsbabel-gpsbabel_${MY_PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc +gui"

BDEPEND="
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-lang/perl
		dev-libs/libxslt
	)
	gui? (
		dev-qt/linguist-tools:5
	)
"
RDEPEND="
	dev-libs/expat
	dev-qt/qtcore:5
	sci-libs/shapelib:=
	sys-libs/zlib[minizip]
	virtual/libusb:0
	gui? (
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebchannel:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README.{contrib,igc,mapconverter,md,xmapwpt} )

RESTRICT="test" # bug 421699

src_prepare() {
	default

	if use doc; then
		cp "${DISTDIR}/gpsbabel.org-style3.css" . || die
	fi
}

src_configure() {
	local myeconfargs=(
		LRELEASE=$(qt5_get_bindir)/lrelease
		LUPDATE=$(qt5_get_bindir)/lupdate
		QMAKE=$(qt5_get_bindir)/qmake
	)
	eqmake5 ${myeconfargs[@]}
}

src_compile() {
	default
	emake

	if use gui; then
		emake unix-gui
	fi

	if use doc; then
		perl xmldoc/makedoc || die
		emake gpsbabel.html
	fi
}

src_install() {
	use doc && local HTML_DOCS=( ${PN}.html ${PN}.org-style3.css )

	dodoc AUTHORS README*
	dobin gpsbabel
	dobin gui/objects/gpsbabelfe
	insinto /usr/share/${PN}/translations/
	doins gui/gpsbabel*_*.qm
	newicon gui/images/appicon.png ${PN}.png
	make_desktop_entry gpsbabelfe ${PN} ${PN} "Science;Geoscience"
}

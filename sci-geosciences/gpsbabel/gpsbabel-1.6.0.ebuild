# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

MY_PV="${PV//./_}"
MY_P="${PN}_${MY_PV}"

DESCRIPTION="GPS waypoints, tracks and routes converter"
HOMEPAGE="https://www.gpsbabel.org/ https://github.com/gpsbabel/gpsbabel"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${MY_P}.tar.gz
	doc? ( https://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="doc +gui"

RDEPEND="
	dev-libs/expat
	dev-qt/qtcore:5
	sci-libs/shapelib:=
	sys-libs/zlib
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
BDEPEND="
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-lang/perl
		dev-libs/libxslt
	)
	gui? ( dev-qt/linguist-tools:5 )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README.{contrib,igc,mapconverter,md,xmapwpt} )

PATCHES=(
	"${FILESDIR}"/${P}-use_system_shapelib.patch
	"${FILESDIR}"/${P}-use_system_zlib.patch
	"${FILESDIR}"/${PN}-1.5.4-xmldoc.patch
	"${FILESDIR}"/${PN}-1.5.4-disable_statistic_uploading.patch
	"${FILESDIR}"/${P}-disable_update_check.patch
	"${FILESDIR}"/${PN}-1.5.4-disable_version_check.patch
	"${FILESDIR}"/${P}-pkgdatadir.patch
)

RESTRICT="test" # bug 421699

S="${WORKDIR}/${PN}-${MY_P}"

src_prepare() {
	default

	# remove bundled libs and cleanup
	rm -r shapelib zlib || die
	sed -i -e "s: zlib\/[a-z]*\.h::g" Makefile.in || die

	use doc && cp "${DISTDIR}/gpsbabel.org-style3.css" "${S}"
}

src_configure() {
	econf \
		$(use_with doc doc "${S}"/doc/manual) \
		LRELEASE=$(qt5_get_bindir)/lrelease \
		LUPDATE=$(qt5_get_bindir)/lupdate \
		QMAKE=$(qt5_get_bindir)/qmake \
		--with-zlib=system

	if use gui; then
		pushd "${S}/gui" > /dev/null || die
		$(qt5_get_bindir)/lrelease *.ts || die
		eqmake5 PREFIX=/usr
		popd > /dev/null
	fi
}

src_compile() {
	default
	if use gui; then
		pushd "${S}/gui" > /dev/null || die
		emake
		popd > /dev/null
	fi

	if use doc; then
		perl xmldoc/makedoc || die
		emake gpsbabel.html
	fi
}

src_install() {
	use doc && HTML_DOCS=( "${S}"/${PN}.html "${S}"/${PN}.org-style3.css )

	default

	if use gui; then
		dobin gui/objects/gpsbabelfe
		insinto /usr/share/${PN}/
		doins gui/gmapbase.html
		insinto /usr/share/${PN}/translations/
		doins gui/gpsbabel*_*.qm
		doins gui/coretool/gpsbabel*_*.qm
		newicon gui/images/appicon.png ${PN}.png
		make_desktop_entry gpsbabelfe ${PN} ${PN} "Science;Geoscience"
	fi
}

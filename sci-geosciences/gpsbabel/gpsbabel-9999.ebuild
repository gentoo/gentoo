# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils qmake-utils

DESCRIPTION="GPS waypoints, tracks and routes converter"
HOMEPAGE="https://www.gpsbabel.org/ https://github.com/gpsbabel/gpsbabel"
LICENSE="GPL-2"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gpsbabel/gpsbabel.git"
	SRC_URI="doc? ( https://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )"
else
	SRC_URI="
		https://dev.gentoo.org/~asturm/${P}.tar.gz
		doc? ( https://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )
	"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

SLOT="0"
IUSE="doc +gui"

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
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-lang/perl
		dev-libs/libxslt
	)
	gui? ( dev-qt/linguist-tools:5 )
"

DOCS=( AUTHORS README.{contrib,igc,mapconverter,md,xmapwpt} )

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.4-disable_statistic_uploading.patch
	"${FILESDIR}"/${PN}-9999-disable_update_check.patch
	"${FILESDIR}"/${PN}-1.5.4-disable_version_check.patch
	"${FILESDIR}"/${PN}-9999-use_system_shapelib.patch
	"${FILESDIR}"/${PN}-9999-xmldoc.patch
)

RESTRICT="test" # bug 421699

src_prepare() {
	default

	# remove bundled libs and cleanup
	rm -r shapelib || die

	use doc && cp "${DISTDIR}/gpsbabel.org-style3.css" "${S}"

	eautoreconf
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
		eqmake5
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
		insinto /usr/share/${PN}/translations/
		doins gui/gpsbabel*_*.qm
		newicon gui/images/appicon.png ${PN}.png
		make_desktop_entry gpsbabelfe ${PN} ${PN} "Science;Geoscience"
	fi
}

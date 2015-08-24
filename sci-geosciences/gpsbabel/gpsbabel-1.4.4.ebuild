# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils qt4-r2 autotools

DESCRIPTION="GPS waypoints, tracks and routes converter"
HOMEPAGE="http://www.gpsbabel.org/"
SRC_URI="
	https://dev.gentoo.org/~patrick/${P}.tar.gz
	doc? ( http://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE="doc qt4"

RDEPEND="
	dev-libs/expat
	sci-libs/shapelib
	virtual/libusb:0
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)
"
DEPEND="${RDEPEND}
	doc? (
		dev-lang/perl
		dev-libs/libxslt
		app-text/docbook-xml-dtd:4.1.2
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-disable_statistic_uploading.patch"
	"${FILESDIR}/${PN}-disable_update_check.patch"
	"${FILESDIR}/${PN}-disable_version_check.patch"
	"${FILESDIR}/${PN}-1.4.3-fix_binary_name.patch"
	"${FILESDIR}/${PN}-freebsd.patch"
	"${FILESDIR}/${PN}-use_system_shapelib.patch"
	"${FILESDIR}/${PN}-xmldoc.patch"
)

src_prepare() {
	epatch ${PATCHES[@]}
	epatch_user
	rm -rf shapelib || die

	use doc && cp "${DISTDIR}/gpsbabel.org-style3.css" "${S}"

	eautoreconf
}

src_configure() {
	econf \
		$(use_with doc doc "${S}"/doc/manual) \
		--with-zlib=system

	if use qt4; then
		pushd "${S}/gui" > /dev/null || die
		lrelease *.ts || die
		eqmake4
		popd > /dev/null
	fi
}

src_compile() {
	emake
	if use qt4; then
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
	default
	dodoc README*

	if use qt4; then
		dobin gui/objects/gpsbabelfe
		insinto /usr/share/qt4/translations/
		doins gui/gpsbabel*_*.qm
		newicon gui/images/appicon.png ${PN}.png
		make_desktop_entry gpsbabelfe ${PN} ${PN} "Science;Geoscience"
	fi

	if use doc; then
		dohtml gpsbabel.*
	fi
}

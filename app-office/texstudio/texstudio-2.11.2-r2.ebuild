# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils prefix qmake-utils xdg-utils

DESCRIPTION="Free cross-platform LaTeX editor (fork from texmakerX)"
HOMEPAGE="https://www.texstudio.org https://github.com/texstudio-org/texstudio"
SRC_URI="mirror://sourceforge/${PN}/${PN}/TeXstudio%20${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="video"

COMMON_DEPEND="
	app-text/hunspell:=
	app-text/poppler[qt5]
	>=dev-libs/quazip-0.7.2[qt5(+)]
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsvg:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	video? ( media-libs/phonon[qt5(+)] )"
RDEPEND="${COMMON_DEPEND}
	app-text/ghostscript-gpl
	app-text/psutils
	media-libs/netpbm
	virtual/latex-base"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}

src_prepare() {
	default
	find hunspell quazip utilities/poppler-data qtsingleapplication -delete || die

	if use video; then
		sed "/^PHONON/s:$:true:g" -i ${PN}.pro || die
	fi

	sed \
		-e '/qtsingleapplication.pri/d' \
		-i ${PN}.pro || die

#	cat >> ${PN}.pro <<- EOF
#	exists(texmakerx_my.pri):include(texmakerx_my.pri)
#	EOF

	cp "${FILESDIR}"/texmakerx_my.pri ${PN}.pri || die
	eprefixify ${PN}.pri

	# fix build with quazip-0.7.2 - bug 597930
	sed -i ${PN}.pro -e "s|include/quazip|&5|" || die
	sed -i ${PN}.pri -i ${PN}.pro -e "s/-lquazip/&5/" || die
}

src_configure() {
	eqmake5 USE_SYSTEM_HUNSPELL=1 USE_SYSTEM_QUAZIP=1
}

src_install() {
	local i
	for i in 16x16 22x22 32x32 48x48 64x64 128x128; do
		insinto /usr/share/icons/hicolor/${i}/apps
		newins utilities/${PN}${i}.png ${PN}.png
	done
	emake DESTDIR="${D}" INSTALL_ROOT="${ED}" install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

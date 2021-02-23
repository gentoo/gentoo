# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_/}"
inherit desktop git-r3 qmake-utils xdg

DESCRIPTION="Free cross-platform LaTeX editor (fork from texmakerX)"
HOMEPAGE="https://www.texstudio.org https://github.com/texstudio-org/texstudio"
EGIT_REPO_URI="https://github.com/texstudio-org/texstudio.git"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
IUSE="video"

DEPEND="
	app-text/hunspell:=
	app-text/poppler[qt5]
	>=dev-libs/quazip-1.0:0=
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
	video? ( >=media-libs/phonon-4.11.0 )
"
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
	app-text/psutils
	media-libs/netpbm
	virtual/latex-base
"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-3.0.5-quazip1.patch" ) # TODO: upstream

src_prepare() {
	xdg_src_prepare

	rm -r src/quazip || die
	# TODO: find hunspell quazip utilities/poppler-data qtsingleapplication -delete || die

	if use video; then
		sed "/^PHONON/s:$:true:g" -i ${PN}.pro || die
	fi

	sed -e "/qtsingleapplication.pri/s/.*/CONFIG += qtsingleapplication/" \
		-i ${PN}.pro || die
}

src_configure() {
	eqmake5 USE_SYSTEM_HUNSPELL=1 USE_SYSTEM_QUAZIP=1
}

src_install() {
	local i
	for i in 16x16 22x22 32x32 48x48 64x64 128x128; do
		newicon -s ${i} utilities/${PN}${i}.png ${PN}.png
	done
	emake DESTDIR="${D}" INSTALL_ROOT="${ED}" install
}

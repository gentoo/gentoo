# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg autotools subversion

DESCRIPTION="Graphical frontend to the LinuxSampler engine"
HOMEPAGE="https://qsampler.sourceforge.io/ https://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/qsampler/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug +libgig"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/alsa-lib
	>=media-libs/liblscp-0.5.6:=
	x11-libs/libX11
	libgig? ( >=media-libs/libgig-3.3.0:= )
"
RDEPEND="${COMMON_DEPEND}
	>=media-sound/linuxsampler-0.5
"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
"

DOCS=( AUTHORS ChangeLog README TODO TRANSLATORS )

PATCHES=( "${FILESDIR}/${PN}-0.5.3-Makefile.patch" )

src_prepare() {
	default

	emake -f Makefile.git
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable libgig)
	)
	ac_qmake="$(qt5_get_bindir)/qmake" \
		econf "${myeconfargs[@]}"

	cd src || die
	eqmake5 src.pro -o Makefile
}

pkg_postinst() {
	# these are not run automagically in live ebuild for some reason so running them manually
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	# these are not run automagically in live ebuild for some reason so running them manually
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

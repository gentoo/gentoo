# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/wxmaxima/wxmaxima-13.04.2.ebuild,v 1.5 2015/04/21 19:24:13 pacho Exp $

EAPI=5

WX_GTK_VER="2.8"

inherit eutils gnome2-utils wxwidgets fdo-mime

MYP=wxMaxima-${PV}

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit"
HOMEPAGE="http://wxmaxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="
	dev-libs/libxml2:2
	x11-libs/wxGTK:${WX_GTK_VER}"
RDEPEND="${DEPEND}
	media-fonts/jsmath
	sci-visualization/gnuplot[wxwidgets]
	sci-mathematics/maxima"

S="${WORKDIR}/${MYP}"

src_prepare() {
	local i

	# consistent package names
	sed -e "s:\${datadir}/wxMaxima:\${datadir}/${PN}:g" \
		-i Makefile.in data/Makefile.in || die "sed failed"

	sed -e 's:share/wxMaxima:share/wxmaxima:g' \
		-i src/wxMaxima.cpp src/wxMaximaFrame.cpp src/Config.cpp \
		|| die "sed failed"

	# correct gettext behavior
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(cd "${S}"/locales ; echo *.mo) ; do
			if ! has ${i%.mo} ${LINGUAS} ; then
				sed -i \
					-e "/^WXMAXIMA_LINGUAS/s# ${i%.mo}##" \
					-e "/^WXWIN_LINGUAS/s# ${i%.mo}##" \
					locales/Makefile.in || die
			fi
		done
	fi
}

src_configure() {
	econf \
		--enable-printing \
		--with-wx-config=${WX_CONFIG}
}

src_install () {
	default
	doicon -s 128 data/wxmaxima.png
	make_desktop_entry wxmaxima wxMaxima wxmaxima
	dosym /usr/share/${PN}/README /usr/share/doc/${PF}/README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

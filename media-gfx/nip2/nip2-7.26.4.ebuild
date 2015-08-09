# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils autotools fdo-mime gnome2-utils versionator

MY_MAJ_VER=$(get_version_component_range 1-2)
DESCRIPTION="VIPS Image Processing Graphical User Interface"
SRC_URI="http://www.vips.ecs.soton.ac.uk/supported/${MY_MAJ_VER}/${P}.tar.gz"
HOMEPAGE="http://vips.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug fftw goffice gsl test"

RDEPEND=">=dev-libs/glib-2.14:2
	dev-libs/libxml2
	x11-misc/xdg-utils
	>=media-libs/vips-${MY_MAJ_VER}
	>=x11-libs/gtk+-2.18:2
	goffice? ( x11-libs/goffice:0.8 )
	gsl? ( sci-libs/gsl )
	fftw? ( sci-libs/fftw:3.0 )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	test? ( media-libs/vips[jpeg,lcms,tiff] )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-7.16.4-fftw3-build.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-update-desktop \
		$(use_enable debug) \
		$(use_with goffice libgoffice) \
		$(use_with gsl) \
		$(use_with fftw fftw3)
}

src_test() {
	if ! use gsl; then
		ewarn "Some tests require USE=gsl. Disabling test_math.ws tests."
		rm test/workspaces/test_math.ws
	fi
	make check || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README* || die
	insinto /usr/share/icons/hicolor/128x128/apps
	newins share/nip2/data/vips-128.png nip2.png || die

	mv "${D}"/usr/share/doc/${PN}/* "${D}"/usr/share/doc/${PF} || die
	rmdir "${D}"/usr/share/doc/${PN}/ || die
	dosym /usr/share/doc/${PF}/html /usr/share/doc/${PN}/
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

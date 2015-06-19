# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/evas_generic_loaders/evas_generic_loaders-1.12.0.ebuild,v 1.2 2014/12/27 19:41:13 tommy Exp $

EAPI=5

inherit enlightenment

MY_P=${PN}-${PV/_/-}

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${MY_P}.tar.bz2"

LOCENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gstreamer pdf postscript raw svg"

S=${WORKDIR}/${MY_P}

RDEPEND="
	>=dev-libs/efl-1.12.2
	gstreamer? ( media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	pdf? ( app-text/poppler )
	postscript? ( app-text/libspectre )
	raw? ( media-libs/libraw )
	svg? ( gnome-base/librsvg
		x11-libs/cairo )"
DEPEND="${RDEPEND}"

src_configure() {
	local MY_ECONF="$(use_enable gstreamer gstreamer1)
		$(use_enable pdf poppler)
		$(use_enable postscript spectre)
		$(use_enable raw libraw)
		$(use_enable svg)

		--disable-gstreamer"

	enlightenment_src_configure
}

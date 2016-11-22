# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P=${PN}-${PV/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${MY_P}.tar.xz"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="https://www.enlightenment.org/"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-interix ~x86-solaris ~x64-solaris"

LICENSE="GPL-2"
IUSE="gstreamer pdf postscript raw svg"

RDEPEND=">=dev-libs/efl-${PV}
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	pdf? ( app-text/poppler )
	postscript? ( app-text/libspectre )
	raw? ( media-libs/libraw )
	svg? (
		gnome-base/librsvg
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	E_ECONF=(
		$(use_enable gstreamer gstreamer1)
		$(use_enable pdf poppler)
		$(use_enable postscript spectre)
		$(use_enable raw libraw)
		$(use_enable svg)

		--disable-gstreamer
	)

	enlightenment_src_configure
}

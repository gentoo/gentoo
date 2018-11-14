# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit ltprune xdg-utils

MY_P="${P/_pre/.}"
MY_PV="${PV/_pre/.}"

DESCRIPTION="On-screen input pad to send characters with mouse"
HOMEPAGE="https://github.com/fujiwarat/input-pad/wiki"
SRC_URI="https://github.com/fujiwarat/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eekboard +introspection static-libs +xtest"

RDEPEND="dev-libs/glib:2
	dev-libs/libxml2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libxklavier
	virtual/libintl
	eekboard? ( dev-libs/eekboard )
	introspection? ( dev-libs/gobject-introspection )
	xtest? ( x11-libs/libXtst )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	econf \
		$(use_enable eekboard eek) \
		$(use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable xtest)
}

src_install() {
	default
	prune_libtool_files
}

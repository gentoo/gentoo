# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils multilib-minimal versionator

MY_MAJ=$(get_version_component_range 1-2)

DESCRIPTION="C++ library to emulate the C64 SID chip"
HOMEPAGE="http://sidplay2.sourceforge.net"
SRC_URI="mirror://sourceforge/sidplay2/${P/_p/-p}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="static-libs"

S=${WORKDIR}/${PN}-${MY_MAJ}

DOCS=(
	AUTHORS ChangeLog NEWS README THANKS TODO VC_CC_SUPPORT.txt
)

src_prepare() {
	default

	# This is required, otherwise the shared libraries get installed as
	# libresid.0.0.0 instead of libresid.so.0.0.0.
	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-dependency-tracking \
		--enable-resid-install \
		--enable-shared
}

multilib_src_install() {
	default

	prune_libtool_files
}

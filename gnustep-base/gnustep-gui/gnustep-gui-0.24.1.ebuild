# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnustep-base multilib

DESCRIPTION="Library of GUI classes written in Obj-C"
HOMEPAGE="http://www.gnustep.org/"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cups gif icu jpeg png speech"

DEPEND="${GNUSTEP_CORE_DEPEND}
	app-text/aspell
	>=gnustep-base/gnustep-base-1.24.6[icu?]
	media-libs/audiofile
	>=media-libs/tiff-3:=
	x11-libs/libXt
	cups? ( >=net-print/cups-1.7.4:= )
	gif? ( >=media-libs/giflib-4.1:= )
	icu? ( dev-libs/icu:= )
	jpeg? ( virtual/jpeg:= )
	png? ( >=media-libs/libpng-1.2:= )
	speech? ( app-accessibility/flite )"
RDEPEND="${DEPEND}"

src_prepare() {
	gnustep-base_src_prepare

	# remove hardcoded -g -Werror, bug #378179
	sed -i -e 's/-g -Werror//' \
		Tools/say/GNUmakefile \
		Tools/speech/GNUmakefile \
		|| die
}

src_configure() {
	egnustep_env

	local myconf=
	use gif && myconf="--disable-ungif --enable-libgif"

	econf \
		$(use_enable cups) \
		$(use_enable icu) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable speech) \
		--with-tiff-include="${EPREFIX}"/usr/include \
		--with-tiff-library="${EPREFIX}"/usr/$(get_libdir) \
		${myconf}
}

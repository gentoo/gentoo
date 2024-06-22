# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-base multilib virtualx

DESCRIPTION="Library of GUI classes written in Obj-C"
HOMEPAGE="https://gnustep.github.io/"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cups icu jpeg png speech"

DEPEND="${GNUSTEP_CORE_DEPEND}
	app-text/aspell
	>=gnustep-base/gnustep-base-1.28.0:=[icu?]
	media-libs/audiofile
	>=media-libs/giflib-4.1:=
	>=media-libs/tiff-3:=
	x11-libs/libXt
	cups? ( >=net-print/cups-1.7.4:= )
	icu? ( dev-libs/icu:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( >=media-libs/libpng-1.2:= )
	speech? ( app-accessibility/flite )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-nssound.patch )

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

	econf \
		$(use_enable cups) \
		$(use_enable icu) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable speech) \
		--disable-ungif --enable-libgif \
		--with-tiff-include="${EPREFIX}"/usr/include \
		--with-tiff-library="${EPREFIX}"/usr/$(get_libdir)
}

src_test() {
	virtx default
}

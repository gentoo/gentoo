# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# vala and introspection support is broken, bug #468208
#VALA_MIN_API_VERSION=0.14
#VALA_USE_DEPEND=vapigen

inherit autotools eutils #vala

DESCRIPTION="A dynamic, any to any, pixel format conversion library"
HOMEPAGE="http://www.gegl.org/babl/"
SRC_URI="ftp://ftp.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="altivec cpu_flags_x86_sse cpu_flags_x86_mmx" # +introspection vala

RDEPEND=""
#introspection? ( >=dev-libs/gobject-introspection-0.10 )"

DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2
	virtual/pkgconfig
"
#vala? ( $(vala_depend) )

src_prepare() {
	epatch "${FILESDIR}"/${P}-clang.patch

	# fix compilation on OSX, can be dropped on next release:
	# http://mail.gnome.org/archives/commits-list/2012-April/msg02589.html
	sed -i -e 's/values\.h/limits.h/' babl/babl-palette.c || die
	epatch "${FILESDIR}"/${P}-introspection.patch
	epatch "${FILESDIR}"/${P}-g-ir-compiler-crash.patch
	eautoreconf

#	use vala && vala_src_prepare
}

src_configure() {
	# Automagic rsvg support is just for website generation we do not call,
	#     so we don't need to fix it
	# w3m is used for dist target thus no issue for us that it is automagically
	#     detected
	econf \
		--disable-static \
		--disable-maintainer-mode \
		--disable-introspection \
		--without-vala \
		$(use_enable altivec) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse)
#		$(use_enable introspection) \
#		$(use_with vala)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
	dodoc AUTHORS ChangeLog README NEWS
}

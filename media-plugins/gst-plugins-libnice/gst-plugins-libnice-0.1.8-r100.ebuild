# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-libnice/gst-plugins-libnice-0.1.8-r100.ebuild,v 1.10 2015/01/02 12:10:18 ago Exp $

EAPI=5
inherit eutils multilib-minimal toolchain-funcs

DESCRIPTION="GStreamer plugin for ICE (RFC 5245) support"
HOMEPAGE="http://nice.freedesktop.org/wiki/"
MY_P=libnice-${PV}
SRC_URI="http://nice.freedesktop.org/releases/${MY_P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="1.0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	~net-libs/libnice-${PV}[${MULTILIB_USEDEP}]
	media-libs/gstreamer:${SLOT}[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-base:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e 's:$(top_builddir)/nice/libnice.la:$(NICE_LIBS):' \
		-i gst/Makefile.{am,in} || die "sed failed"
}

multilib_src_configure() {
	# gupnp is not used in the gst plugin
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--without-gstreamer-0.10 \
		--with-gstreamer \
		--disable-introspection \
		--disable-gupnp
}

multilib_src_compile() {
	emake -C gst \
		NICE_LIBS="$($(tc-getPKG_CONFIG) --libs-only-l nice)"
}

multilib_src_test() {
	:
}

multilib_src_install() {
	emake -C gst DESTDIR="${D}" install
}

multilib_src_install_all() {
	prune_libtool_files --modules
}

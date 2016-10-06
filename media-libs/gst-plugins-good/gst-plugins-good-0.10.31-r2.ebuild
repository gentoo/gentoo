# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE="gst-plugins-good"
inherit eutils flag-o-matic gstreamer

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+orc"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-0.10.36:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-0.10.36:${SLOT}[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	!<media-libs/gst-plugins-bad-0.10.22:${SLOT}
"
# audioparsers and qtmux moves

src_configure() {
	# gst doesnt handle optimisations well
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # see bug 22249

	multilib-minimal_src_configure
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.10-clang.patch"
}

multilib_src_configure() {
	# Always enable optional bz2 support for matroska
	# Always enable optional zlib support for qtdemux and matroska
	# Many media files require these to work, as some container headers are often
	# compressed, bug #291154
	gstreamer_multilib_src_configure \
		--enable-bz2 \
		--enable-zlib \
		--disable-examples \
		--with-default-audiosink=autoaudiosink \
		--with-default-visualizer=goom
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}

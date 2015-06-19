# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-base/gst-plugins-base-0.10.36-r1.ebuild,v 1.14 2015/03/03 08:29:01 dlan Exp $

EAPI="5"

GST_ORG_MODULE="gst-plugins-base"
inherit eutils gstreamer

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+introspection nls +orc"

RDEPEND=">=media-libs/gstreamer-${PV}:0.10[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	app-text/iso-codes
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.3
"
RDEPEND="${RDEPEND}
	!<media-libs/gst-plugins-bad-0.10.10:0.10
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-medialibs-20140508-r5
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)]
	)
"

src_prepare() {
	# The AC_PATH_XTRA macro unnecessarily pulls in libSM and libICE even
	# though they are not actually used. This needs to be fixed upstream by
	# replacing AC_PATH_XTRA with PKG_CONFIG calls.
	sed -i -e 's:X_PRE_LIBS -lSM -lICE:X_PRE_LIBS:' "${S}"/configure || die

	# Fix compilation with gcc-4.9, bug #529962
	epatch "${FILESDIR}"/${PN}-0.10.36-gcc-4.9.patch
}

multilib_src_configure() {
	gstreamer_multilib_src_configure \
		$(multilib_native_use_enable introspection) \
		$(use_enable nls) \
		$(use_enable orc) \
		--disable-examples \
		--disable-debug \
		--disable-static

	# bug #366931, flag-o-matic for the whole thing is overkill
	if [[ ${CHOST} == *86-*-darwin* ]] ; then
		sed -i \
			-e '/FLAGS = /s|-O[23]|-O1|g' \
			gst/audioconvert/Makefile \
			gst/volume/Makefile || die
	fi

	if multilib_is_native_abi; then
		local x
		for x in libs plugins; do
			ln -s "${S}"/docs/${x}/html docs/${x}/html || die
		done
	fi
}

multilib_src_install_all() {
	DOCS="AUTHORS NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}

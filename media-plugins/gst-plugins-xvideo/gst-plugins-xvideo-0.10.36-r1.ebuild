# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GST_ORG_MODULE=gst-plugins-base
inherit gstreamer

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

# xshm is a compile time option of xvideo
# x is needed to build any X plugins, but we build/install only xv anyway
GST_PLUGINS_BUILD="x xvideo xshm"
GST_PLUGINS_BUILD_DIR="xvimage"

src_prepare() {
	# The AC_PATH_XTRA macro unnecessarily pulls in libSM and libICE even
	# though they are not actually used. This needs to be fixed upstream by
	# replacing AC_PATH_XTRA with PKG_CONFIG calls.
	sed -i -e 's:X_PRE_LIBS -lSM -lICE:X_PRE_LIBS:' "${S}"/configure

	gstreamer_system_link \
		gst-libs/gst/video:gstreamer-video \
		gst-libs/gst/interfaces:gstreamer-interfaces
}

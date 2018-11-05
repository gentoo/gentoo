# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

MY_PN="gst-libav"
DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"

GIT_COMMIT="db8235024523a0375443f36eb5fec627386452d5"
COMMON_GIT_COMMIT="ed78bee437dcbe22e6eef0031d9a29d157c0461f"
SRC_URI="https://gitlab.freedesktop.org/gstreamer/gst-libav/-/archive/${GIT_COMMIT}/gst-libav-${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://gitlab.freedesktop.org/gstreamer/common/-/archive/${COMMON_GIT_COMMIT}/common-${COMMON_GIT_COMMIT}.tar.gz -> gstreamer-common-${COMMON_GIT_COMMIT}.tar.gz"
S=${WORKDIR}/${MY_PN}-${GIT_COMMIT}

PATCHES=(
	"${FILESDIR}/${P}-00_plugin-dependencies.patch"
	"${FILESDIR}/${P}-01_disable-1.15-api.patch"
	"${FILESDIR}/${P}-02_drop-1.15-dependency.patch"
	"${FILESDIR}/${P}-03_avmux-Place-pva-case-after-generic-case.patch"
	"${FILESDIR}/${P}-04_decoders-fix-draining.patch"
)

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~x86 ~x86-fbsd"
IUSE="libav +orc"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.14:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.14:1.0[${MULTILIB_USEDEP}]
	!libav? ( >=media-video/ffmpeg-4:0=[${MULTILIB_USEDEP}] )
	libav? (
		app-arch/bzip2[${MULTILIB_USEDEP}]
		app-arch/xz-utils[${MULTILIB_USEDEP}]
	)
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare(){
	# common is a git submodule
	# submodules are not included in gitlab archives
	# see https://gitlab.com/gitlab-org/gitlab-ce/issues/28882
	# So common is downloaded seperately and placed appropriately
	rm -rf common || die
	mv "${WORKDIR}/common-${COMMON_GIT_COMMIT}" common || die
	default
	eautoreconf
}

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	# Upstream dropped support for system libav and won't work
	# for preserving its compat anymore, forcing us to rely on internal
	# ffmpeg copy if we don't want to cause unresolvable blockers for
	# libav setups.
	# https://bugzilla.gnome.org/show_bug.cgi?id=758183
	# Prefer system ffmpeg for -libav
	local myconf

	if use libav; then
		ewarn "Using internal ffmpeg copy as upstream dropped"
		ewarn "the support for compiling against system libav"
		ewarn "https://bugzilla.gnome.org/show_bug.cgi?id=758183"
	else
		myconf="--with-system-libav"
	fi

	ECONF_SOURCE=${S} \
	econf \
		--disable-maintainer-mode \
		--with-package-name="Gentoo GStreamer ebuild" \
		--with-package-origin="https://www.gentoo.org" \
		--disable-fatal-warnings \
		$(use_enable orc) \
		${myconf}
}

multilib_src_compile() {
	# Don't build with -Werror
	emake ERROR_CFLAGS=
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

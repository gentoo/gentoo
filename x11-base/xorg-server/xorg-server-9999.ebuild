# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson xorg-3

DESCRIPTION="X.Org X servers"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/xserver"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/xserver.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE_SERVERS="dmx kdrive wayland xephyr xnest xorg xvfb"
IUSE="${IUSE_SERVERS} debug elogind +glamor ipv6 libressl libglvnd minimal selinux +suid systemd +udev unwind xcsecurity"

CDEPEND="libglvnd? (
		media-libs/libglvnd
		!app-eselect/eselect-opengl
	)
	!libglvnd? ( >=app-eselect/eselect-opengl-1.3.0	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	>=x11-apps/iceauth-1.0.2
	>=x11-apps/rgb-1.0.3
	>=x11-apps/xauth-1.0.3
	x11-apps/xkbcomp
	>=x11-libs/libdrm-2.4.89
	>=x11-libs/libpciaccess-0.12.901
	>=x11-libs/libXau-1.0.4
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont2-2.0.1
	>=x11-libs/libxkbfile-1.0.4
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-libs/xtrans-1.3.5
	>=x11-misc/xbitmaps-1.0.1
	>=x11-misc/xkeyboard-config-2.4.1-r3
	dmx? (
		x11-libs/libXt
		>=x11-libs/libdmx-1.0.99.1
		>=x11-libs/libX11-1.1.5
		>=x11-libs/libXaw-1.0.4
		>=x11-libs/libXext-1.0.99.4
		>=x11-libs/libXfixes-5.0
		>=x11-libs/libXi-1.2.99.1
		>=x11-libs/libXmu-1.0.3
		x11-libs/libXrender
		>=x11-libs/libXres-1.0.3
		>=x11-libs/libXtst-1.0.99.2
	)
	glamor? (
		media-libs/libepoxy[X,egl(+)]
		>=media-libs/mesa-18[egl,gbm]
		!x11-libs/glamor
	)
	kdrive? (
		>=x11-libs/libXext-1.0.5
		x11-libs/libXv
	)
	xephyr? (
		x11-libs/libxcb[xkb]
		x11-libs/xcb-util
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
	!minimal? (
		>=x11-libs/libX11-1.1.5
		>=x11-libs/libXext-1.0.5
		>=media-libs/mesa-18[X(+)]
	)
	udev? ( virtual/libudev:= )
	unwind? ( sys-libs/libunwind )
	wayland? (
		>=dev-libs/wayland-1.3.0
		media-libs/libepoxy[egl(+)]
		>=dev-libs/wayland-protocols-1.18
	)
	>=x11-apps/xinit-1.3.3-r1
	systemd? (
		sys-apps/dbus
		sys-apps/systemd
	)
	elogind? (
		sys-apps/dbus
		sys-auth/elogind
		sys-auth/pambase[elogind]
	)
	"

DEPEND="${CDEPEND}
	sys-devel/flex
	>=x11-base/xorg-proto-2018.4
	dmx? (
		doc? (
			|| (
				www-client/links
				www-client/lynx
				www-client/w3m
			)
		)
	)"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-xserver )
	!x11-drivers/xf86-video-modesetting
"

PDEPEND="
	xorg? ( >=x11-base/xorg-drivers-$(ver_cut 1-2) )"

REQUIRED_USE="!minimal? (
		|| ( ${IUSE_SERVERS} )
	)
	elogind? ( udev )
	?? ( elogind systemd )
	minimal? ( !glamor !wayland )
	xephyr? ( kdrive )"

UPSTREAMED_PATCHES=(
)

PATCHES=(
	"${UPSTREAMED_PATCHES[@]}"
	"${FILESDIR}"/${PN}-1.12-unloadsubmodule.patch
	# needed for new eselect-opengl, bug #541232
	"${FILESDIR}"/${PN}-1.18-support-multiple-Files-sections.patch
)

pkg_setup() {
	if use wayland && ! use glamor; then
		ewarn "glamor is necessary for acceleration under Xwayland."
		ewarn "Performance may be unacceptable without it."
	fi

}

src_prepare() {
	default
}

src_configure() {
	# localstatedir is used for the log location; we need to override the default
	#	from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies
	# NOTE: fop is used for doc generating; and I have no idea if Gentoo
	#	package it somewhere
	local emesonargs=(
		$(meson_use ipv6)
		--buildtype $(usex debug debug plain)
		$(meson_use dmx)
		$(meson_use glamor)
		# rolled under xephyr
		# $(use_enable kdrive)
		# doesn't seem to be handled in meson
		# $(use_enable unwind libunwind)
		$(meson_use wayland xwayland)
		# not optional under meson
		# $(use_enable !minimal record)
		# $(use_enable !minimal xfree86-utils)
		$(meson_use !minimal dri1)
		$(meson_use !minimal dri2)
		$(meson_use !minimal dri3)
		$(meson_use !minimal glx)
		$(meson_use xcsecurity)
		$(meson_use xephyr)
		$(meson_use xnest)
		$(meson_use xorg)
		$(meson_use xvfb)
		$(meson_use udev)
		# not handled under meson
		# $(use_with doc doxygen)
		# $(use_with doc xmlto)
		# no meson_options.txt entry to set this; its auto.
		# $(use_with systemd systemd-daemon)
		$(meson_use systemd systemd_logind)
		$(meson_use systemd suid_wrapper)
		# not handled under meson
		# $(use_enable !systemd install-setuid)
		# not configurable via meson
		# --enable-libdrm
		--sysconfdir="${EPREFIX}"/etc/X11
		--localstatedir="${EPREFIX}"/var
		# meson.build uses pkgconfig fontconfig to get this, we may be able to
		# let it just 'do its thing'
		-Ddefault_font_path="${EPREFIX}"/usr/share/fonts
		-Dxkb_output_dir="${EPREFIX}"/var/lib/xkb
		-Dhal=false
		-Dlinux_acpi=false
		# not handled in meson that I can see
		# --without-dtrace
		# --without-fop
		-Dvendor_name=Gentoo
		# not handled in meson that I can see
		# --with-sha1=libcrypto
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install

	server_based_install

	# if ! use minimal && use xorg; then
	# 	Install xorg.conf.example into docs
	# 	generated by autotools build, doesn't exist in meson yet
	# 	dodoc "${AUTOTOOLS_BUILD_DIR}"/hw/xfree86/xorg.conf.example
	# fi

	newinitd "${FILESDIR}"/xdm-setup.initd-1 xdm-setup
	newinitd "${FILESDIR}"/xdm.initd-11 xdm
	newconfd "${FILESDIR}"/xdm.confd-4 xdm

	# install the @x11-module-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/xorg-sets.conf xorg.conf
	# meson build doesn't create any /var directory at all atm
	# find "${ED}"/var -type d -emtpy -delete || die
}

pkg_postinst() {
	if ! use minimal; then
		# sets up libGL and DRI2 symlinks if needed (ie, on a fresh install)
		if ! use libglvnd; then
			eselect opengl set xorg-x11 --use-old
		fi
	fi
}

pkg_postrm() {
	# Get rid of module dir to ensure opengl-update works properly
	if [[ -z ${REPLACED_BY_VERSION} && -e ${EROOT}/usr/$(get_libdir)/xorg/modules ]]; then
		rm -rf "${EROOT}"/usr/$(get_libdir)/xorg/modules
	fi
}

server_based_install() {
	if ! use xorg; then
		rm "${ED}"/usr/share/man/man1/Xserver.1x \
			"${ED}"/usr/$(get_libdir)/xserver/SecurityPolicy \
			"${ED}"/usr/$(get_libdir)/pkgconfig/xorg-server.pc \
			"${ED}"/usr/share/man/man1/Xserver.1x
	fi
}

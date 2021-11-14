# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DOC=doc
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3 meson
EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/xserver.git"
XORG_EAUTORECONF="no"

DESCRIPTION="X.Org X servers"
SLOT="0/${PV}"
if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

IUSE_SERVERS="xephyr xnest xorg xvfb"
IUSE="${IUSE_SERVERS} debug +elogind ipv6 minimal selinux suid systemd test +udev unwind xcsecurity"
RESTRICT="!test? ( test )"

CDEPEND="
	media-libs/libglvnd[X]
	dev-libs/openssl:0=
	>=x11-apps/iceauth-1.0.2
	>=x11-apps/rgb-1.0.3
	>=x11-apps/xauth-1.0.3
	x11-apps/xkbcomp
	>=x11-libs/libdrm-2.4.89
	>=x11-libs/libpciaccess-0.12.901
	>=x11-libs/libXau-1.0.4
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont2-2.0.1
	>=x11-libs/libxcvt-0.1.0
	>=x11-libs/libxkbfile-1.0.4
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-misc/xbitmaps-1.0.1
	>=x11-misc/xkeyboard-config-2.4.1-r3
	>=x11-libs/libXext-1.0.5
	x11-libs/libXv
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
		>=media-libs/mesa-18[X(+),egl(+),gbm(+)]
		>=media-libs/libepoxy-1.5.4[X,egl(+)]
	)
	udev? ( virtual/libudev:= )
	unwind? ( sys-libs/libunwind )
	>=x11-apps/xinit-1.3.3-r1
	systemd? (
		sys-apps/dbus
		sys-apps/systemd
	)
	elogind? (
		sys-apps/dbus
		sys-auth/elogind[pam]
		sys-auth/pambase[elogind]
	)
	!!x11-drivers/nvidia-drivers[-libglvnd(+)]
"
DEPEND="${CDEPEND}
	>=x11-base/xorg-proto-2021.4.99.2
	>=x11-libs/xtrans-1.3.5
"
RDEPEND="${CDEPEND}
	!systemd? ( gui-libs/display-manager-init )
	selinux? ( sec-policy/selinux-xserver )
"
BDEPEND="
	sys-devel/flex
"
PDEPEND="
	xorg? ( >=x11-base/xorg-drivers-$(ver_cut 1-2) )"

REQUIRED_USE="!minimal? (
		|| ( ${IUSE_SERVERS} )
	)
	elogind? ( udev )
	?? ( elogind systemd )"

UPSTREAMED_PATCHES=(
)

PATCHES=(
	"${UPSTREAMED_PATCHES[@]}"
	"${FILESDIR}"/${PN}-1.12-unloadsubmodule.patch
	# needed for new eselect-opengl, bug #541232
	"${FILESDIR}"/${PN}-1.18-support-multiple-Files-sections.patch
)

src_configure() {
	# localstatedir is used for the log location; we need to override the default
	#	from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies
	# NOTE: fop is used for doc generating; and I have no idea if Gentoo
	#	package it somewhere

	local emesonargs=(
		--localstatedir "${EPREFIX}/var"
		--sysconfdir "${EPREFIX}/etc/X11"
		$(meson_use ipv6)
		$(meson_use debug)
		$(meson_use unwind libunwind)
		$(meson_use !minimal dri1)
		$(meson_use !minimal dri2)
		$(meson_use !minimal dri3)
		$(meson_use !minimal glx)
		$(meson_use !minimal glamor)
		$(meson_use xcsecurity)
		$(meson_use xephyr)
		$(meson_use xnest)
		$(meson_use xorg)
		$(meson_use xvfb)
		$(meson_use udev)
		$(meson_use udev udev_kms)
		$(meson_use doc docs)
		-Ddrm=true
		-Dxwayland=false
		-Dxkb_output_dir="${EPREFIX}/var/lib/xkb"
		-Dhal=false
		-Dlinux_acpi=false
		-Ddtrace=false
		-Dsha1=libcrypto
		-Ddefault_font_path="${EPREFIX}"/usr/share/fonts
	)

	if use systemd || use elogind; then
		emesonargs+=(
			-Dsystemd_logind=true
			$(meson_use suid suid_wrapper)
		)
	else
		emesonargs+=(
			-Dsystemd_logind=false
			$(meson_use suid suid_wrapper)
		)
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	#The new meson build system do not leave X symlink
	ln -s Xorg "${ED}"/usr/bin/X

	if ! use xorg; then
		rm -f "${ED}"/usr/share/man/man1/Xserver.1x \
			"${ED}"/usr/$(get_libdir)/xserver/SecurityPolicy \
			"${ED}"/usr/$(get_libdir)/pkgconfig/xorg-server.pc \
			"${ED}"/usr/share/man/man1/Xserver.1x || die
	fi

	# install the @x11-module-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/xorg-sets.conf xorg.conf
}

pkg_postrm() {
	# Get rid of module dir to ensure opengl-update works properly
	if [[ -z ${REPLACED_BY_VERSION} && -e ${EROOT}/usr/$(get_libdir)/xorg/modules ]]; then
		rm -rf "${EROOT}"/usr/$(get_libdir)/xorg/modules
	fi
}

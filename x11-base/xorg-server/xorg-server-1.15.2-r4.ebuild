# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_EAUTORECONF=yes
XORG_DOC=doc
inherit xorg-2 multilib versionator flag-o-matic
EGIT_REPO_URI="git://anongit.freedesktop.org/git/xorg/xserver"

DESCRIPTION="X.Org X servers"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

SRC_URI="${SRC_URI} mirror://gentoo/${PN}-1.16-cve-2014-8091..8103.patches.tar.xz"

IUSE_SERVERS="dmx kdrive xnest xorg xvfb"
IUSE="${IUSE_SERVERS} ipv6 minimal nptl selinux +suid tslib +udev unwind"

CDEPEND=">=app-eselect/eselect-opengl-1.3.0
	dev-libs/openssl:0
	media-libs/freetype
	>=x11-apps/iceauth-1.0.2
	>=x11-apps/rgb-1.0.3
	>=x11-apps/xauth-1.0.3
	x11-apps/xkbcomp
	>=x11-libs/libdrm-2.4.20
	>=x11-libs/libpciaccess-0.12.901
	>=x11-libs/libXau-1.0.4
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont-1.4.2
	<x11-libs/libXfont-1.5.0
	>=x11-libs/libxkbfile-1.0.4
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-libs/xtrans-1.3.2
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
	kdrive? (
		>=x11-libs/libXext-1.0.5
		x11-libs/libXv
	)
	!minimal? (
		>=x11-libs/libX11-1.1.5
		>=x11-libs/libXext-1.0.5
		>=media-libs/mesa-10.3.7-r2[nptl=]
	)
	tslib? ( >=x11-libs/tslib-1.0 )
	udev? ( >=virtual/udev-150 )
	unwind? ( sys-libs/libunwind )
	>=x11-apps/xinit-1.3"

DEPEND="${CDEPEND}
	sys-devel/flex
	>=x11-proto/bigreqsproto-1.1.0
	>=x11-proto/compositeproto-0.4
	>=x11-proto/damageproto-1.1
	>=x11-proto/fixesproto-5.0
	>=x11-proto/fontsproto-2.0.2
	<x11-proto/fontsproto-2.1.3
	>=x11-proto/glproto-1.4.17-r1
	>=x11-proto/inputproto-2.2.99.1
	>=x11-proto/kbproto-1.0.3
	>=x11-proto/randrproto-1.4.0
	>=x11-proto/recordproto-1.13.99.1
	>=x11-proto/renderproto-0.11
	>=x11-proto/resourceproto-1.2.0
	>=x11-proto/scrnsaverproto-1.1
	>=x11-proto/trapproto-3.4.3
	>=x11-proto/videoproto-2.2.2
	>=x11-proto/xcmiscproto-1.2.0
	>=x11-proto/xextproto-7.2.99.901
	>=x11-proto/xf86dgaproto-2.0.99.1
	>=x11-proto/xf86rushproto-1.1.2
	>=x11-proto/xf86vidmodeproto-2.2.99.1
	>=x11-proto/xineramaproto-1.1.3
	>=x11-proto/xproto-7.0.22
	>=x11-proto/presentproto-1.0
	>=x11-proto/dri3proto-1.0
	dmx? (
		>=x11-proto/dmxproto-2.2.99.1
		doc? (
			|| (
				www-client/links
				www-client/lynx
				www-client/w3m
			)
		)
	)
	!minimal? (
		>=x11-proto/xf86driproto-2.1.0
		>=x11-proto/dri2proto-2.8
	)"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-xserver )
"

PDEPEND="
	xorg? ( >=x11-base/xorg-drivers-$(get_version_component_range 1-2) )"

REQUIRED_USE="!minimal? (
		|| ( ${IUSE_SERVERS} )
	)"

pkg_pretend() {
	# older gcc is not supported
	[[ "${MERGE_TYPE}" != "binary" && $(gcc-major-version) -lt 4 ]] && \
		die "Sorry, but gcc earlier than 4.0 will not work for xorg-server."
}

src_prepare() {
	UPSTREAMED_PATCHES=(
		"${WORKDIR}"/patches/*.patch
	)
	PATCHES=(
		"${UPSTREAMED_PATCHES[@]}"
		"${FILESDIR}"/${PN}-1.12-ia64-fix_inx_outx.patch
		"${FILESDIR}"/${PN}-1.12-unloadsubmodule.patch
		"${FILESDIR}"/${PN}-1.17-cve-2015-0255-0.patch
		"${FILESDIR}"/${PN}-1.17-cve-2015-0255-1.patch
		"${FILESDIR}"/${PN}-1.17.2-uninit-clientsWritable.patch
	)
	xorg-2_src_prepare
}

src_configure() {
	# localstatedir is used for the log location; we need to override the default
	#	from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies
	# NOTE: fop is used for doc generating ; and i have no idea if gentoo
	#	package it somewhere
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_enable dmx)
		$(use_enable kdrive)
		$(use_enable kdrive kdrive-kbd)
		$(use_enable kdrive kdrive-mouse)
		$(use_enable kdrive kdrive-evdev)
		$(use_enable suid install-setuid)
		$(use_enable tslib)
		$(use_enable unwind libunwind)
		$(use_enable !minimal record)
		$(use_enable !minimal xfree86-utils)
		$(use_enable !minimal install-libxf86config)
		$(use_enable !minimal dri)
		$(use_enable !minimal dri2)
		$(use_enable !minimal glx)
		$(use_enable xnest)
		$(use_enable xorg)
		$(use_enable xvfb)
		$(use_enable nptl glx-tls)
		$(use_enable udev config-udev)
		$(use_with doc doxygen)
		$(use_with doc xmlto)
		--enable-libdrm
		--sysconfdir="${EPREFIX}"/etc/X11
		--localstatedir="${EPREFIX}"/var
		--with-fontrootdir="${EPREFIX}"/usr/share/fonts
		--with-xkb-output="${EPREFIX}"/var/lib/xkb
		--disable-config-hal
		--disable-linux-acpi
		--without-dtrace
		--without-fop
		--with-os-vendor=Gentoo
		--with-sha1=libcrypto
	)

	xorg-2_src_configure
}

src_install() {
	xorg-2_src_install

	server_based_install

	if ! use minimal &&	use xorg; then
		# Install xorg.conf.example into docs
		dodoc "${AUTOTOOLS_BUILD_DIR}"/hw/xfree86/xorg.conf.example
	fi

	newinitd "${FILESDIR}"/xdm-setup.initd-1 xdm-setup
	newinitd "${FILESDIR}"/xdm.initd-11 xdm
	newconfd "${FILESDIR}"/xdm.confd-4 xdm

	# install the @x11-module-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/xorg-sets.conf xorg.conf
}

pkg_postinst() {
	# sets up libGL and DRI2 symlinks if needed (ie, on a fresh install)
	eselect opengl set xorg-x11 --use-old

	if [[ ${PV} != 9999 && $(get_version_component_range 2 ${REPLACING_VERSIONS}) != $(get_version_component_range 2 ${PV}) ]]; then
		ewarn "You must rebuild all drivers if upgrading from <xorg-server-$(get_version_component_range 1-2)"
		ewarn "because the ABI changed. If you cannot start X because"
		ewarn "of module version mismatch errors, this is your problem."

		echo
		ewarn "You can rebuild all installed packages in the x11-drivers"
		ewarn "category using this command:"
		ewarn "	emerge @x11-module-rebuild"
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

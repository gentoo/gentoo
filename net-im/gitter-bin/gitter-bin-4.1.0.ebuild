# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
MY_PN="${PN/-bin/}"

inherit desktop gnome2-utils multilib-build pax-utils unpacker

QA_PREBUILT="opt/gitter/pnacl/pnacl_public_x86_64_libcrt_platform_a
	opt/gitter/pnacl/pnacl_public_x86_64_pnacl_llc_nexe
	opt/gitter/pnacl/pnacl_public_x86_64_ld_nexe
	opt/gitter/pnacl/pnacl_public_x86_64_pnacl_sz_nexe
	opt/gitter/payload
	opt/gitter/swiftshader/libEGL.so
	opt/gitter/swiftshader/libGLESv2.so
	opt/gitter/chromedriver
	opt/gitter/lib/libnw.so
	opt/gitter/lib/libnode.so
	opt/gitter/lib/libffmpeg.so
	opt/gitter/nacl_helper
	opt/gitter/nwjc
	opt/gitter/nacl_irt_x86_64.nexe
	opt/gitter/Gitter"

DESCRIPTION="Chat and network platform"
HOMEPAGE="http://www.gitter.im/"
SRC_URI="
	amd64? ( https://update.gitter.im/linux64/${MY_PN}_${PV}_amd64.deb )
	x86? ( https://update.gitter.im/linux32/${MY_PN}_${PV}_i386.deb )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="pax_kernel"
RESTRICT="bindist mirror"

RDEPEND="dev-libs/atk:0[${MULTILIB_USEDEP}]
	dev-libs/expat:0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr:0[${MULTILIB_USEDEP}]
	dev-libs/nss:0[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	sys-apps/dbus:0[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libX11:0[${MULTILIB_USEDEP}]
	x11-libs/libxcb:0/1.12[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:0[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:0[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:0[${MULTILIB_USEDEP}]
	x11-libs/libXext:0[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:0[${MULTILIB_USEDEP}]
	x11-libs/libXi:0[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:0[${MULTILIB_USEDEP}]
	x11-libs/libXrender:0[${MULTILIB_USEDEP}]
	x11-libs/libXtst:0[${MULTILIB_USEDEP}]
	x11-libs/pango:0[${MULTILIB_USEDEP}]"
DEPEND="sys-apps/fix-gnustack"

S="${WORKDIR}"

src_prepare() {
	default

	local arch
	arch="$(usex amd64 "64" "32")"

	# Modify desktop file to use common paths
	sed -i \
		-e '/Exec/s/=.*/=\/usr\/bin\/gitter/' \
		-e '/Icon/s/=.*/=\/usr\/share\/pixmaps\/gitter.png/' \
		opt/Gitter/linux"${arch}"/gitter.desktop || die "sed failed"
}

src_install() {
	local arch
	arch="$(usex amd64 "64" "32")"

	fix-gnustack -f opt/Gitter/linux"${arch}"/nacl_irt_x86_64.nexe > /dev/null \
		|| die "removing execstack flag failed"

	newicon opt/Gitter/linux"${arch}"/logo.png gitter.png
	newicon -s 256 opt/Gitter/linux"${arch}"/logo.png gitter.png
	domenu opt/Gitter/linux"${arch}"/gitter.desktop

	insinto /opt/gitter
	doins -r opt/Gitter/linux"${arch}"/.
	fperms +x /opt/gitter/Gitter
	dosym ../../opt/gitter/Gitter /usr/bin/gitter

	use pax_kernel && pax-mark -m "${ED%/}"/opt/gitter/Gitter
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

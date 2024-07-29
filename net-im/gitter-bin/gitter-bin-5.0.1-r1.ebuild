# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit desktop multilib-build pax-utils unpacker xdg

MY_PN="${PN/-bin/}"

DESCRIPTION="Chat and network platform"
HOMEPAGE="https://gitter.im"
SRC_URI="amd64? ( https://update.gitter.im/linux64/${MY_PN}_${PV}_amd64.deb )
	x86? ( https://update.gitter.im/linux32/${MY_PN}_${PV}_i386.deb )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="abi_x86_32 +abi_x86_64"
RESTRICT="bindist mirror strip"

RDEPEND="app-accessibility/at-spi2-core:2[${MULTILIB_USEDEP}]
	dev-libs/atk:0[${MULTILIB_USEDEP}]
	dev-libs/expat:0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr:0[${MULTILIB_USEDEP}]
	dev-libs/nss:0[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	net-print/cups:0[${MULTILIB_USEDEP}]
	sys-apps/dbus:0[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libdrm:0[${MULTILIB_USEDEP}]
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
	x11-libs/libXScrnSaver:0[${MULTILIB_USEDEP}]
	x11-libs/libXtst:0[${MULTILIB_USEDEP}]
	x11-libs/pango:0[${MULTILIB_USEDEP}]"

S="${WORKDIR}"

QA_EXECSTACK="opt/gitter/pnacl/pnacl_public_x86_64_libcrt_platform_a*"
QA_PREBUILT="opt/gitter/pnacl/pnacl_public_x86_64_pnacl_llc_nexe
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
QA_FLAGS_IGNORED="opt/gitter/minidump_stackwalk
	opt/gitter/nacl_helper_bootstrap
	opt/gitter/crashpad_handler
	opt/gitter/lib/libEGL.so
	opt/gitter/lib/libGLESv2.so"

src_prepare() {
	default

	local arch
	multilib_get_enabled_abis
	arch="$(usex amd64 "64" "32")"

	# Remove hardcoded paths
	sed -i \
		-e '/Exec/s/=.*/=gitter/' \
		-e '/Icon/s/=.*/=gitter/' \
		opt/Gitter/linux"${arch}"/gitter.desktop || die "sed failed"
}

src_install() {
	local arch
	arch="$(usex amd64 "64" "32")"

	newicon opt/Gitter/linux"${arch}"/logo.png gitter.png
	newicon -s 256 opt/Gitter/linux"${arch}"/logo.png gitter.png
	domenu opt/Gitter/linux"${arch}"/gitter.desktop

	insinto /opt/gitter
	doins -r opt/Gitter/linux"${arch}"/.
	fperms -R +x /opt/gitter/lib/ /opt/gitter/swiftshader/ \
		/opt/gitter/pnacl/pnacl_public_x86_64_{ld_nexe,pnacl_llc_nexe,pnacl_sz_nexe} \
		/opt/gitter/{Gitter,chromedriver,crashpad_handler,minidump_stackwalk,nwjc,payload} \
		/opt/gitter/nacl_{helper,helper_bootstrap,irt_x86_64.nexe}

	dosym ../../opt/gitter/Gitter /usr/bin/gitter

	pax-mark -m "${ED}"/opt/gitter/Gitter
}

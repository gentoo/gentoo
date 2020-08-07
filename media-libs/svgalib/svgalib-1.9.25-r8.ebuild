# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-mod toolchain-funcs

DESCRIPTION="A library for running svga graphics on the console"
HOMEPAGE="http://www.svgalib.org/"
SRC_URI="http://www.arava.co.il/matan/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="build +kernel-helper"

MODULE_NAMES="svgalib_helper(misc:${S}/kernel/svgalib_helper)"
BUILD_TARGETS="default"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.25-linux_2.6.patch
	"${FILESDIR}"/${PN}-1.9.19-pic.patch
	"${FILESDIR}"/${PN}-1.9.25-build.patch
	"${FILESDIR}"/${PN}-1.9.25-linux_2.6.28.patch
	"${FILESDIR}"/${PN}-1.9.25-glibc210.patch
	"${FILESDIR}"/${PN}-1.9.25-linux_2.6.36-r1.patch
	"${FILESDIR}"/${PN}-1.9.25-fix_buffer.patch
	"${FILESDIR}"/${PN}-1.9.25-vga_reset.patch
	"${FILESDIR}"/${PN}-1.9.25-missing_include.patch
	"${FILESDIR}"/${PN}-1.9.25-linux_3.4.patch
	"${FILESDIR}"/${PN}-1.9.25-linux_3.9.patch
	"${FILESDIR}"/${PN}-1.9.25-no-man-compression.patch
	"${FILESDIR}"/${PN}-1.9.25-wrapdemo-buf-overflow.patch
)

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KDIR=${KV_OUT_DIR}"
}

src_prepare() {
	default
	sed -i -e '/linux\/smp_lock.h/d' kernel/svgalib_helper/main.c || die
	convert_to_m kernel/svgalib_helper/Makefile
}

src_compile() {
	use kernel-helper || export NO_HELPER=y

	export CC=$(tc-getCC)
	# C89 extern inlines are needed, see #576260
	append-cflags -fgnu89-inline

	# First build static
	emake OPTIMIZE="${CFLAGS}" static
	# Then build shared ...
	emake OPTIMIZE="${CFLAGS}" shared
	emake OPTIMIZE="${CFLAGS}" LDFLAGS+=" -L../sharedlib" \
		textutils lrmi utils
	# Build threeDKit ...
	emake OPTIMIZE="${CFLAGS}" LDFLAGS+=" -L../sharedlib" \
		-C threeDKit lib3dkit.a
	# Build demo's ...
	emake OPTIMIZE="${CFLAGS} -I../gl" LDFLAGS+=" -L../sharedlib" \
		demoprogs

	! use build && use kernel-helper && linux-mod_src_compile
}

src_install() {
	local x

	dodir /etc/svgalib /usr/{include,lib,bin,share/man}

	emake \
		TOPDIR="${D}" OPTIMIZE="${CFLAGS}" INSTALLMODULE="" \
		install
	! use build && use kernel-helper && linux-mod_src_install

	insinto /usr/include
	doins gl/vgagl.h
	dolib.a staticlib/libvga.a
	dolib.a staticlib/libvgagl.a
	dolib.a threeDKit/lib3dkit.a

	insinto /usr/include
	doins src/vga.h gl/vgagl.h src/mouse/vgamouse.h src/joystick/vgajoystick.h
	doins src/keyboard/vgakeyboard.h kernel/svgalib_helper/svgalib_helper.h

	insinto /lib/udev/rules.d
	newins "${FILESDIR}"/svgalib.udev.rules.d.2 30-svgalib.rules

	exeinto /usr/lib/svgalib/demos
	for x in "${S}"/demos/* ; do
		[[ -x ${x} ]] && doexe ${x}
	done

	cd "${S}"/threeDKit || die
	exeinto /usr/lib/svgalib/threeDKit
	local THREED_PROGS="plane wrapdemo"
	doexe ${THREED_PROGS}

	cd "${ED}/usr/$(get_libdir)" || die
	ln -s libvga.so.${PV} libvga.so.1 || die
	ln -s libvgagl.so.${PV} libvgagl.so.1 || die
	ln -s lib3dkit.so.${PV} lib3dkit.so.1 || die
	ln -sf libvga.so.1 libvga.so || die
	ln -sf libvgagl.so.1 libvgagl.so || die
	ln -sf lib3dkit.so.1 lib3dkit.so || die

	cd "${S}" || die
	dodoc 0-README
	cd "${S}"/doc || die
	dodoc CHANGES DESIGN TODO
	docinto txt
	dodoc Driver-programming-HOWTO add_driver svgalib.lsm \
		README.{joystick,keymap,multi-monitor,patching,vesa}
	# avoid installation of a broken symlink
	newdoc ../lrmi-0.6m/README README.lrmi
}

pkg_postinst() {
	! use build && use kernel-helper && linux-mod_pkg_postinst
}

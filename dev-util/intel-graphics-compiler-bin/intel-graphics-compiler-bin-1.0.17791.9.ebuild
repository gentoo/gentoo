# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PN="igc"
MY_PN_LONG="intel-graphics-compiler"

DESCRIPTION="LLVM-based OpenCL compiler for OpenCL targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="
	https://github.com/intel/${MY_PN_LONG}/releases/download/${MY_PN}-${PV}/intel-${MY_PN}-core_${PV}_amd64.deb
	https://github.com/intel/${MY_PN_LONG}/releases/download/${MY_PN}-${PV}/intel-${MY_PN}-media_${PV}_amd64.deb
	https://github.com/intel/${MY_PN_LONG}/releases/download/${MY_PN}-${PV}/intel-${MY_PN}-opencl_${PV}_amd64.deb
	https://github.com/intel/${MY_PN_LONG}/releases/download/${MY_PN}-${PV}/intel-${MY_PN}-opencl-devel_${PV}_amd64.deb
	"

LICENSE="MIT"
SLOT="legacy/1.0.1"
KEYWORDS="~amd64"

DEPEND="
	dev-util/spirv-tools
"

RDEPEND="
	!dev-util/intel-graphics-compiler
	${DEPEND}
"

S="${WORKDIR}"

src_compile(){
	sed -i "s#/usr/local#${EROOT}/usr#g" usr/local/lib/pkgconfig/igc-opencl.pc
	sed -i "s#/lib#/$(get_libdir)#g" usr/local/lib/pkgconfig/igc-opencl.pc
}

src_install() {
	dobin usr/local/bin/*
	dolib.so usr/local/lib/lib*
	dodoc usr/local/lib/igc/NOTICES.txt
	doheader -r usr/local/include/igc/ usr/local/include/opencl-c-base.h usr/local/include/opencl-c.h usr/local/include/visa/ usr/local/include/iga/
	insinto "${EROOT}/usr/$(get_libdir)/pkgconfig/"
	doins usr/local/lib/pkgconfig/igc-opencl.pc
}

# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="tools for processing UEFI firmware content (EfiRom, GenFfs, ...)"
HOMEPAGE="https://github.com/tianocore/edk2"
# Same source as sys-firmware/edk2-ovmf so share the tarball
SRC_URI="https://github.com/tianocore/edk2/archive/edk2-stable${PV}.tar.gz -> edk2-ovmf-${PV}.tar.gz"
S="${WORKDIR}/edk2-edk2-stable${PV}/BaseTools"
LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# util-linux for libuuid.so
DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"

# Includes manuals but RTF-formatted
BDEPEND="sys-apps/help2man"

src_prepare() {
	default

	# Remove brotli which depends on git submodules
	sed -i -e '/BrotliCompress/d' Source/C/GNUmakefile || die
}

src_compile() {
	emake -C Source/C \
		BUILD_CC="${CC}" \
		BUILD_CXX="${CXX}" \
		BUILD_AS="${AS}" \
		BUILD_AR="${AR}" \
		BUILD_LD="${LD}"
}

src_install() {
	dobin Source/C/bin/*

	for bin in Source/C/bin/*; do
		help2man -s1 -n "$(basename "$bin")" -N -o "$bin".1 $bin
		doman "$bin".1
	done
}

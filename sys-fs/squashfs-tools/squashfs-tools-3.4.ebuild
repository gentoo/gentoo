# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit toolchain-funcs

MY_PV=${PV/_p/-r}
DESCRIPTION="Tool for creating compressed filesystem type squashfs"
HOMEPAGE="http://squashfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/squashfs/squashfs${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="3.1" # squashfs filesystem version
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

S=${WORKDIR}/squashfs${MY_PV}/squashfs-tools

src_prepare() {
	sed -i \
		-e 's:-O2:$(CFLAGS):' \
		-e '/-lz/s:$: $(LDFLAGS):' \
		Makefile || die

	sed -i -e 's:get_nprocs():sysconf(_SC_NPROCESSORS_ONLN):' *.c
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	newbin mksquashfs mksquashfs-${SLOT}
	newbin unsquashfs unsquashfs-${SLOT}
	cd ..
	dodoc README ACKNOWLEDGEMENTS CHANGES PERFORMANCE.README README
}

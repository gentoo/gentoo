# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV="$(ver_cut 1-2)$(ver_cut 4-5)"

DESCRIPTION="Lightweight ASCII art demo using media-libs/aalib"
HOMEPAGE="https://aa-project.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/aa-project/bb/${MY_PV}/bb-${MY_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="mikmod"

DEPEND="media-libs/aalib:=
	dev-libs/lzo:=
	mikmod? ( media-libs/libmikmod:=[openal] )
"
# media-libs/libmikmod[openal] is due to bug #516964
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

PATCHES=(
	"${FILESDIR}"/${P}-noattr.patch
	"${FILESDIR}"/${P}-fix-protos.patch
	"${FILESDIR}"/${P}-messager-overlap.patch
	"${FILESDIR}"/${P}-zbuff-fault.patch
	"${FILESDIR}"/${P}-printf-cleanup.patch
	"${FILESDIR}"/${P}-libmikmod-pkgconfig.patch
	"${FILESDIR}"/${P}-protos.patch
	"${FILESDIR}"/${P}-disable-pulse.patch
	"${FILESDIR}"/${P}-fix-build-for-clang16.patch
	"${FILESDIR}"/${P}-fix-lto-type-mismatch.patch
	"${FILESDIR}"/${P}-fix-return-type-and-QA.patch
)

src_prepare() {
	default

	# unbundle lzo, #515286
	rm -v README.LZO minilzo.{c,h} mylzo.h || die
	sed -e 's/minilzo.c//' \
		-e 's/minilzo.h//' \
		-e 's/README.LZO//' \
		-i Makefile.am || die
	echo 'bb_LDADD = -llzo2' >> Makefile.am || die
	# update code
	sed -e 's,#include "minilzo.h",#include <lzo/lzo1x.h>,' \
		-e 's,int size = image,lzo_uint size = image,' \
		-i image.c || die

	# rename binary and manpage bb -> bb-aalib

	mv bb.1 bb-aalib.1 || die
	sed -e 's/bb/bb-aalib/' \
		-i bb-aalib.1
	sed -e 's/bin_PROGRAMS = bb/bin_PROGRAMS = bb-aalib/' \
		-e 's/man_MANS = bb.1/man_MANS = bb-aalib.1/'     \
		-e 's/bb_SOURCES/bb_aalib_SOURCES/'               \
		-e 's/bb_LDADD/bb_aalib_LDADD/'                   \
		-i Makefile.am || die

	mv -v configure.{in,ac} || die
	# m4/ dir is added with 'm4-stuff.patch' patch
	AT_M4DIR="m4" eautoreconf
}

pkg_postinst() {
	elog "bb binary has been renamed to bb-aalib to avoid a naming conflict with sys-apps/busybox."
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="A set of utilities for converting to/from the netpbm (and related) formats"
HOMEPAGE="https://netpbm.sourceforge.net/"
SRC_URI="https://github.com/ceamac/netpbm-make-dist/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="jbig jpeg png postscript rle cpu_flags_x86_sse2 static-libs svga tiff X xml"

BDEPEND="
	app-arch/xz-utils
	sys-devel/flex
	virtual/pkgconfig
"
# app-text/ghostscript-gpl is really needed for postscript
# some utilities execute /usr/bin/gs
RDEPEND="jbig? ( media-libs/jbigkit:= )
	jpeg? ( media-libs/libjpeg-turbo:=[static-libs?] )
	png? (
		>=media-libs/libpng-1.4:0=
		sys-libs/zlib
	)
	postscript? (
		app-text/ghostscript-gpl
		sys-libs/zlib
	)
	rle? ( media-libs/urt:= )
	svga? ( media-libs/svgalib )
	tiff? ( >=media-libs/tiff-3.5.5:0 )
	xml? ( dev-libs/libxml2 )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/netpbm-10.86.21-build.patch
	"${FILESDIR}"/netpbm-10.86.21-test.patch #450530
	"${FILESDIR}"/netpbm-10.86.21-misc-deps.patch
	"${FILESDIR}"/netpbm-10.86.22-fix-ps-test.patch #670362
)

netpbm_libtype() {
	case ${CHOST} in
		*-darwin*) echo dylib;;
		*)         echo unixshared;;
	esac
}

netpbm_libsuffix() {
	local suffix=$(get_libname)
	echo ${suffix//\.}
}

netpbm_ldshlib() {
	case ${CHOST} in
		*-darwin*) echo '$(LDFLAGS) -dynamiclib -install_name $(SONAME)';;
		*)         echo '$(LDFLAGS) -shared -Wl,-soname,$(SONAME)';;
	esac
}
netpbm_config() {
	if use ${1} ; then
		[[ ${2} != "!" ]] && echo -l${2:-$1}
	else
		echo NONE
	fi
}

# for bug #828127
netpbm_cflags_for_build() {
	if is-flagq -fPIC; then
		echo -fPIC
	fi
}

src_prepare() {
	default

	# make sure we use system libs
	sed -i '/SUPPORT_SUBDIRS/s:urt::' GNUmakefile || die
	rm -r urt converter/other/jbig/libjbig converter/other/jpeg2000/libjasper || die

	# take care of the importinc stuff ourselves by only doing it once
	# at the top level and having all subdirs use that one set #149843
	sed -i \
		-e '/^importinc:/s|^|importinc:\nmanual_|' \
		-e '/-Iimportinc/s|-Iimp|-I"$(BUILDDIR)"/imp|g'\
		common.mk || die
	sed -i \
		-e '/%.c/s: importinc$::' \
		common.mk lib/Makefile lib/util/Makefile || die
	sed -i \
		-e 's:pkg-config:$(PKG_CONFIG):' \
		GNUmakefile converter/other/Makefile other/pamx/Makefile || die

	# The postscript knob is currently bound up with a fork test.
	if ! use postscript ; then
		sed -i \
			-e 's:$(DONT_HAVE_PROCESS_MGMT):Y:' \
			converter/other/Makefile generator/Makefile || die
		sed -i -r \
			-e 's:(pbmtextps|pnmtops|pstopnm).*::' \
			test/all-in-place.{ok,test} || die
		sed -i -e 's:lps-roundtrip.*::' test/Test-Order || die
		sed -i -e '/^$/d' test/all-in-place.ok || die
		sed -i '2iexit 80' test/ps-{alt-,flate-,}roundtrip.test || die
	fi

	# the new postscript test needs +x
	chmod +x test/lps-roundtrip.test

	# Do not test png if not built
	if ! use png ; then
		sed -i -r \
			-e 's:(pamtopng|pngtopam|pnmtopng).*::' \
			test/all-in-place.{ok,test} || die
		sed -i -e '/^$/d' test/all-in-place.ok || die

		sed -i -r \
			-e 's:(pamrgbatopng|pngtopnm).*::' \
			test/legacy-names.{ok,test} || die
		sed -i -e '/^$/d' test/legacy-names.ok || die
		sed -i -e 's:png-roundtrip.*::' test/Test-Order || die
	fi

	# this test requires LC_ALL=en_US.iso88591, not available on musl
	if use elibc_musl; then
		sed -i -e 's:pbmtext-iso88591.*::' test/Test-Order || die
	fi
}

src_configure() {
	# cannot chain the die with the heredoc
	# repoman tries to parse the heredoc and fails
	cat config.mk.in - >> config.mk <<-EOF
	# Misc crap
	BUILD_FIASCO = N
	SYMLINK = ln -sf

	# These vars let src_test work by default
	PKGDIR_DEFAULT = ${T}/netpbm
	RESULTDIR_DEFAULT = ${T}/netpbm-test

	# Toolchain options
	CC = $(tc-getCC) -Wall
	LD = \$(CC)
	CC_FOR_BUILD = $(tc-getBUILD_CC)
	LD_FOR_BUILD = \$(CC_FOR_BUILD)
	AR = $(tc-getAR)
	RANLIB = $(tc-getRANLIB)
	PKG_CONFIG = $(tc-getPKG_CONFIG)

	STRIPFLAG =
	CFLAGS_SHLIB = -fPIC
	CFLAGS_FOR_BUILD += $(netpbm_cflags_for_build)

	LDRELOC = \$(LD) -r
	LDSHLIB = $(netpbm_ldshlib)
	LINKER_CAN_DO_EXPLICIT_LIBRARY = N # we can, but dont want to
	LINKERISCOMPILER = Y
	NETPBMLIBSUFFIX = $(netpbm_libsuffix)
	NETPBMLIBTYPE = $(netpbm_libtype)
	STATICLIB_TOO = $(usex static-libs Y N)

	# The var is called SSE, but the code is actually SSE2.
	WANT_SSE = $(usex cpu_flags_x86_sse2 Y N)

	# Gentoo build options
	TIFFLIB = $(netpbm_config tiff)
	# Let tiff worry about its own dependencies #395753
	TIFFLIB_NEEDS_JPEG = N
	TIFFLIB_NEEDS_Z = N
	JPEGLIB = $(netpbm_config jpeg)
	PNGLIB = $(netpbm_config png)
	ZLIB = $($(tc-getPKG_CONFIG) --libs zlib)
	LINUXSVGALIB = $(netpbm_config svga vga)
	XML2_LIBS = $(netpbm_config xml xml2)
	JBIGLIB = $(netpbm_config jbig)
	JBIGHDR_DIR =
	JASPERLIB = NONE
	JASPERHDR_DIR =
	URTLIB = $(netpbm_config rle)
	URTHDR_DIR =
	X11LIB = $(netpbm_config X X11)
	X11HDR_DIR =
	EOF
	[[ $? -eq 0 ]] || die "writing config.mk failed"
}

src_compile() {
	emake -j1 pm_config.h version.h manual_importinc #149843
	emake
}

src_test() {
	# The code wants to install everything first and then test the result.
	emake install.{bin,lib,data}
	emake check
}

src_install() {
	# Subdir make targets like to use `mkdir` all over the place
	# without any actual dependencies, thus the -j1.
	emake -j1 package pkgdir="${ED}"/usr

	if [[ $(get_libdir) != "lib" ]] ; then
		mv "${ED}"/usr/lib "${ED}"/usr/$(get_libdir) || die
	fi

	# Remove cruft that we don't need, and move around stuff we want
	rm "${ED}"/usr/{README,VERSION,{pkgconfig,config}_template,pkginfo} || die

	dodir /usr/share
	mv "${ED}"/usr/misc "${ED}"/usr/share/netpbm || die

	doman userguide/*.[0-9]
	dodoc README

	cd doc || die
	dodoc HISTORY Netpbm.programming USERDOC
	docinto html
	dodoc -r *.html
	dodoc -r ../userguide/*.html
}

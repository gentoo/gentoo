# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib toolchain-funcs

# Upstream has 3 flavors of netpbm: super stable, stable and advanced.
# They only provide a tarball for super stable, but super stable is a bit lagging.
# So we package the stable branch of their svn (currently versions 11.2.xx) on SLOT "0/stable[.rev]"
# and the advanced branch of their svn (currently versions 11.3.yy) on SLOT "0/advanced[.rev]".
# The stable branch is stabilized according to usual Gentoo rules, while the
# advanced branch will not be stabilized.
# A detailed explanation is here https://netpbm.sourceforge.net/release.html

DESCRIPTION="A set of utilities for converting to/from the netpbm (and related) formats"
HOMEPAGE="https://netpbm.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="Artistic BSD GPL-2 IJG LGPL-2.1 MIT public-domain"
SLOT="0/stable"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="jbig jpeg png postscript rle cpu_flags_x86_sse2 static-libs svga tiff X xml"

# app-text/ghostscript-gpl is really needed for postscript
# some utilities execute /usr/bin/gs
# some installed programs are perl scripts
RDEPEND="
	dev-lang/perl
	jbig? ( media-libs/jbigkit:= )
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
	tiff? ( >=media-libs/tiff-3.5.5:= )
	xml? ( dev-libs/libxml2 )
	X? ( x11-libs/libX11 )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-arch/xz-utils
	app-alternatives/lex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/netpbm-10.86.21-build.patch
	"${FILESDIR}"/netpbm-11.0.0-misc-deps.patch
	"${FILESDIR}"/netpbm-11.1.0-fix-clang-O2.patch
	"${FILESDIR}"/netpbm-11.2.7-fix-pnmcolormap2-test.patch
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

netpbm_config_lib() {
	usex ${1} -l${2:-$1} NONE
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

	# fix typo in a test
	sed -i \
		-e 's:^o#! /bin/sh:#! /bin/sh:' \
		test/stdin-ppm3.test || die

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
		sed -i \
			-e 's:lps-roundtrip.*::' \
			-e 's:pbmtextps-dump.*::' \
			-e 's:pbmtextps.*::' \
			test/Test-Order || die
		sed -i \
			-e '/^$/d' \
			test/all-in-place.ok || die
		sed -i \
			'2iexit 80' \
			test/ps-{alt-,flate-,}roundtrip.test || die
	fi

	# the new postscript test needs +x
	chmod +x test/lps-roundtrip.test || die

	# Do not test png if not built
	if ! use png ; then
		sed -i -E \
			-e 's:(pamtopng|pngtopam|pnmtopng).*::' \
			test/all-in-place.{ok,test} || die
		sed -i \
			-e '/^$/d' \
			test/all-in-place.ok || die

		sed -i -E \
			-e 's:(pamrgbatopng|pngtopnm).*::' \
			test/legacy-names.{ok,test} || die
		sed -i \
			-e '/^$/d' \
			test/legacy-names.ok || die
		sed -i \
			-e 's:png-roundtrip.*::' \
			-e 's:winicon-roundtrip.*::' \
			test/Test-Order || die
	fi

	# this test requires LC_ALL=en_US.iso88591, not available on musl
	# ppmpat-random is broken on musl
	# bug #907295
	if use elibc_musl; then
		sed -i \
			-e 's:pbmtext-iso88591.*::' \
			-e 's:ppmpat-random.*::' \
			-i test/Test-Order || die
	fi
}

src_configure() {
	cat config.mk.in - >> config.mk <<-EOF || die "writing config.mk failed"
		# Misc stuff
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
		TIFFLIB = $(netpbm_config_lib tiff)
		# Let tiff worry about its own dependencies #395753
		TIFFLIB_NEEDS_JPEG = N
		TIFFLIB_NEEDS_Z = N
		JPEGLIB = $(netpbm_config_lib jpeg)
		PNGLIB = $(netpbm_config_lib png)
		ZLIB = $($(tc-getPKG_CONFIG) --libs zlib)
		LINUXSVGALIB = $(netpbm_config_lib svga vga)
		XML2_LIBS = $(netpbm_config_lib xml xml2)
		JBIGLIB = $(netpbm_config_lib jbig)
		JBIGHDR_DIR =
		JASPERLIB = NONE
		JASPERHDR_DIR =
		URTLIB = $(netpbm_config_lib rle)
		URTHDR_DIR =
		X11LIB = $(netpbm_config_lib X X11)
		X11HDR_DIR =
	EOF
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
	dodoc -r ../userguide/*.html
}

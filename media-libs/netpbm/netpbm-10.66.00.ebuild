# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit toolchain-funcs eutils multilib

DESCRIPTION="A set of utilities for converting to/from the netpbm (and related) formats"
HOMEPAGE="http://netpbm.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc jbig jpeg png rle cpu_flags_x86_sse2 static-libs svga tiff X xml zlib"

RDEPEND="jbig? ( media-libs/jbigkit )
	jpeg? ( virtual/jpeg:0 )
	png? ( >=media-libs/libpng-1.4:0 )
	rle? ( media-libs/urt )
	svga? ( media-libs/svgalib )
	tiff? ( >=media-libs/tiff-3.5.5:0 )
	xml? ( dev-libs/libxml2 )
	zlib? ( sys-libs/zlib )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	sys-devel/flex"

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
	if use $1 ; then
		[[ $2 != "!" ]] && echo -l${2:-$1}
	else
		echo NONE
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/netpbm-10.31-build.patch
	epatch "${FILESDIR}"/netpbm-10.66-test.patch #450530
	epatch "${FILESDIR}"/netpbm-10.66-jasper-hack.patch #513240
	epatch "${FILESDIR}"/netpbm-10.66-options-case.patch
	epatch "${FILESDIR}"/netpbm-10.66-jpeg-dirs.patch
	epatch "${FILESDIR}"/netpbm-10.66-jbig-2.patch
	epatch "${FILESDIR}"/netpbm-10.66-failing-tests.patch
	epatch "${FILESDIR}"/netpbm-10.66-wordaccess_be_aligned.patch #547252

	# make sure we use system urt
	sed -i '/SUPPORT_SUBDIRS/s:urt::' GNUmakefile || die
	rm -rf urt

	# avoid mixing the local copy of jbig with the system
	rm converter/other/jbig/jbig.h || die

	# disable certain tests based on active USE flags
	local del=(
		$(usex jbig '' 'jbigtopnm pnmtojbig jbig-roundtrip')
		$(usex rle '' 'utahrle-roundtrip')
		$(usex tiff '' 'tiff-roundtrip')
	)
	if [[ ${#del[@]} -gt 0 ]] ; then
		sed -i -r $(printf -- ' -e /%s.test/d' "${del[@]}") test/Test-Order || die
	fi
	del=(
		pnmtofiasco fiascotopnm # We always disable fiasco
		$(usex jbig '' 'jbigtopnm pnmtojbig')
		jpeg2ktopam pamtojpeg2k # jasper has been removed
		$(usex rle '' 'pnmtorle rletopnm')
		$(usex tiff '' 'pamtotiff pnmtotiff pnmtotiffcmyk tifftopnm')
	)
	if [[ ${#del[@]} -gt 0 ]] ; then
		sed -i -r $(printf -- ' -e s/\<%s\>(:.ok)?//' "${del[@]}") test/all-in-place.{ok,test} || die
		sed -i '/^$/d' test/all-in-place.ok || die
	fi

	# take care of the importinc stuff ourselves by only doing it once
	# at the top level and having all subdirs use that one set #149843
	sed -i \
		-e '/^importinc:/s|^|importinc:\nmanual_|' \
		-e '/-Iimportinc/s|-Iimp|-I"$(BUILDDIR)"/imp|g'\
		common.mk || die
	sed -i \
		-e '/%.c/s: importinc$::' \
		common.mk lib/Makefile lib/util/Makefile || die

	# avoid ugly depend.mk warnings
	touch $(find . -name Makefile | sed s:Makefile:depend.mk:g)
}

src_configure() {
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

	STRIPFLAG =
	CFLAGS_SHLIB = -fPIC

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
	ZLIB = $(netpbm_config zlib z)
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
	# cannot chain the die with the heredoc above as bash-3
	# has a parser bug in that setup #282902
	[ $? -eq 0 ] || die "writing config.mk failed"
}

src_compile() {
	emake -j1 pm_config.h version.h manual_importinc #149843
	emake
}

src_test() {
	# The code wants to install everything first and then test the result.
	emake install.{bin,lib}
	emake check
}

src_install() {
	# Subdir make targets like to use `mkdir` all over the place
	# without any actual dependencies, thus the -j1.
	emake -j1 package pkgdir="${ED}"/usr

	[[ $(get_libdir) != "lib" ]] && mv "${ED}"/usr/lib "${ED}"/usr/$(get_libdir)

	# Remove cruft that we don't need, and move around stuff we want
	rm "${ED}"/usr/bin/{doc.url,manweb} || die
	rm -r "${ED}"/usr/man/web || die
	rm -r "${ED}"/usr/link || die
	rm "${ED}"/usr/{README,VERSION,{pkgconfig,config}_template,pkginfo} || die
	dodir /usr/share
	mv "${ED}"/usr/man "${ED}"/usr/share/ || die
	mv "${ED}"/usr/misc "${ED}"/usr/share/netpbm || die

	doman userguide/*.[0-9]
	use doc && dohtml -r userguide
	dodoc README
	cd doc
	dodoc HISTORY Netpbm.programming USERDOC
	dohtml -r .
}

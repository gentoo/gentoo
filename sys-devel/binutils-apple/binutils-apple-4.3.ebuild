# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs

RESTRICT="test" # the test suite will test what's installed.

LD64=ld64-128.2
CCTOOLS=cctools-822
LIBUNWIND=libunwind-30
DYLD=dyld-195.6
# http://lists.apple.com/archives/Darwin-dev/2009/Sep/msg00025.html
UNWIND=binutils-apple-3.2-unwind-patches-5

DESCRIPTION="Darwin assembler as(1) and static linker ld(1), Xcode Tools ${PV}"
HOMEPAGE="http://www.opensource.apple.com/darwinsource/"
SRC_URI="http://www.opensource.apple.com/tarballs/ld64/${LD64}.tar.gz
	http://www.opensource.apple.com/tarballs/cctools/${CCTOOLS}.tar.gz
	http://www.opensource.apple.com/tarballs/libunwind/${LIBUNWIND}.tar.gz
	http://www.opensource.apple.com/tarballs/dyld/${DYLD}.tar.gz
	https://www.gentoo.org/~grobian/distfiles/${UNWIND}.tar.xz
	https://www.gentoo.org/~grobian/distfiles/libunwind-llvm-115426.tar.bz2"

LICENSE="APSL-2"
KEYWORDS="~x64-macos ~x86-macos"
IUSE="lto test"

RDEPEND="sys-devel/binutils-config
	lto? ( sys-devel/llvm )"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/perl-5.8.8 )
	>=sys-devel/gcc-apple-4.2.1"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

if is_cross ; then
	SLOT="${CTARGET}-4"
else
	SLOT="4"
fi

LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${PV}
INCPATH=${LIBPATH}/include
DATAPATH=/usr/share/binutils-data/${CTARGET}/${PV}
if is_cross ; then
	BINPATH=/usr/${CHOST}/${CTARGET}/binutils-bin/${PV}
else
	BINPATH=/usr/${CTARGET}/binutils-bin/${PV}
fi

S=${WORKDIR}

src_prepare() {
	cd "${S}"/${LIBUNWIND}/src
	cp "${FILESDIR}"/${LIBUNWIND}-Makefile Makefile

	cd "${S}"/${LD64}/src
	cp "${FILESDIR}"/ld64-128.2-Makefile Makefile
	epatch "${FILESDIR}"/ld64-127.2-lto.patch
	epatch "${FILESDIR}"/ld64-128.2-stdlib.patch

	ln -s ../../${CCTOOLS}/include
	cp other/prune_trie.h include/mach-o/ || die
	# use our own copy of lto.h, which doesn't require llvm build-env
	mkdir -p include/llvm-c || die
	cp "${WORKDIR}"/ld64-unwind/ld64-97.14-llvm-lto.h include/llvm-c/lto.h || die
	# make libunwind sources known
	ln -s ../../${LIBUNWIND}/src libunwind || die
	cp ../../${LIBUNWIND}/include/*.h include/ || die
	# mimic OS X Lion-style Availability.h macros
	if [[ ${CHOST} == *darwin* && ${CHOST#*-darwin} -le 10 ]] ; then
		{
			echo "#define __OSX_AVAILABLE_STARTING(x,y)  "
			echo "#define __OSX_AVAILABLE_BUT_DEPRECATED(a,b,c,d)  "
		} > include/Availability.h
	fi

	echo '' > configure.h
	echo '' > linker_opts
	local VER_STR="\"@(#)PROGRAM:ld  PROJECT:${LD64} (Gentoo ${PN}-${PVR})\\n\""
	echo "char ldVersionString[] = ${VER_STR};" > version.cpp

	epatch "${FILESDIR}"/ld64-123.2-debug-backtrace.patch
	if use !lto ; then
		sed -i -e '/#define LTO_SUPPORT 1/d' other/ObjectDump.cpp || die
	fi

	cd "${S}"/${CCTOOLS}
	epatch "${FILESDIR}"/${PN}-4.0-as.patch
	epatch "${FILESDIR}"/${PN}-4.2-as-dir.patch
	epatch "${FILESDIR}"/${PN}-3.2.3-ranlib.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-libtool-ranlib.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-nmedit.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-no-headers.patch
	epatch "${FILESDIR}"/${PN}-4.0-no-oss-dir.patch
	epatch "${FILESDIR}"/${PN}-4.2-lto.patch

	local program
	for program in ar efitools gprof libmacho misc otool ; do
		VER_STR="@(#)PROGRAM:${program}  PROJECT:${CCTOOLS} (Gentoo ${PN}-${PVR}) DEVELOPER:${PORTAGE_ROOT_USER}  BUILT:$(date)"
		cat > ${program}/vers.c <<- _EOF
			#include <sys/cdefs.h>
			__IDSTRING(SGS_VERS,"${VER_STR}\n");
		_EOF
		[[ ${program} != "libmacho" ]] && \
			echo '__IDSTRING(VERS_NUM,"apple");' >> ${program}/vers.c
	done

	VER_STR="${CCTOOLS} (Gentoo ${PN}-${PVR})"
	echo "const char apple_version[] = \"${VER_STR}\";" \
		>> as/apple_version.c || die
	echo "const char apple_version[] = \"${VER_STR})\";" \
		>> efitools/vers.c || die
	echo "const char apple_version[] = \"${VER_STR})\";" \
		>> ld/ld_vers.c || die
	echo "const char apple_version[] = \"${VER_STR})\";" \
		>> misc/vers.c || die

	# clean up test suite
	cd "${S}"/${LD64}
#	epatch "${FILESDIR}"/${PN}-3.1.1-testsuite.patch

	cd "${S}"/${LD64}/unit-tests/test-cases
	local c

	# we don't have llvm
	((++c)); rm -rf llvm-integration;

	# we don't have dtrace
	((++c)); rm -rf dtrace-static-probes-coalescing;
	((++c)); rm -rf dtrace-static-probes;

	# a file is missing
	((++c)); rm -rf eh-coalescing-r

	# we don't do universal binaries
	((++c)); rm -rf blank-stubs;

	# looks like a problem with apple's result-filter.pl
	((++c)); rm -rf implicit-common3;
	((++c)); rm -rf order_file-ans;

	# TODO no idea what goes wrong here
	((++c)); rm -rf dwarf-debug-notes;

	einfo "Deleted $c tests that were bound to fail"

	cd "${S}"
	ebegin "cleaning Makefiles from unwanted CFLAGS"
	find . -name "Makefile" -print0 | xargs -0 sed \
		-i \
		-e 's/ -g / /g' \
		-e 's/^OFLAG =.*$/OFLAG =/' \
		-e 's/install -c -s/install/g'
	eend $?

	# -pg is used and the two are incompatible
	filter-flags -fomit-frame-pointer
}

src_configure() {
	tc-export CC CXX AR
	if use lto ; then
		append-cppflags -DLTO_SUPPORT
		append-ldflags -L"${EPREFIX}"/usr/$(get_libdir)/llvm
		append-libs LTO
		LTO=1
	else
		append-cppflags -ULTO_SUPPORT
		LTO=0
	fi
	append-cppflags -DNDEBUG
	append-cppflags -I"${WORKDIR}"/libunwind/include
}

compile_libunwind() {
	# not used, just for testing, and possible use in the future
	einfo "building ${LIBUNWIND}"
	cd "${S}"/${LIBUNWIND}/src
	emake DYLDINCS=-I../../${DYLD}/include || die
}

compile_ld64() {
	einfo "building ${LD64}"
	cd "${S}"/${LD64}/src
	# remove antiquated copy that's available on any OSX system and
	# breaks ld64 compilation
	mv include/mach-o/dyld.h{,.disable}
	emake \
		LTO=${LTO} \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS} -I../../${DYLD}/include" \
		LDFLAGS="${LDFLAGS} ${LIBS}" \
		|| die "emake failed for ld64"
	use test && emake build_test
	# restore, it's necessary for cctools' install
	mv include/mach-o/dyld.h{.disable,}
}

compile_cctools() {
	einfo "building ${CCTOOLS}"
	cd "${S}"/${CCTOOLS}
	# -j1 because it fails too often with weird errors
	emake \
		LIB_PRUNETRIE="-L../../${LD64}/src -lprunetrie" \
		EFITOOLS= LTO= \
		COMMON_SUBDIRS='libstuff ar misc otool' \
		SUBDIRS_32= \
		RC_CFLAGS="${CFLAGS}" OFLAG="${CFLAGS}" \
		-j1 \
		|| die "emake failed for the cctools"
	cd "${S}"/${CCTOOLS}/as
	emake \
		BUILD_OBSOLETE_ARCH= \
		RC_CFLAGS="-DASLIBEXECDIR=\"\\\"${EPREFIX}${LIBPATH}/\\\"\" ${CFLAGS}" \
		|| die "emake failed for as"
}

src_compile() {
	compile_ld64
	compile_cctools
}

install_ld64() {
	exeinto ${BINPATH}
	doexe "${S}"/${LD64}/src/{ld64,rebase,dyldinfo,unwinddump,ObjectDump}
	dosym ld64 ${BINPATH}/ld
	insinto ${DATAPATH}/man/man1
	doins "${S}"/${LD64}/doc/man/man1/{ld,ld64,rebase}.1
}

install_cctools() {
	cd "${S}"/${CCTOOLS}
	emake install_all_but_headers \
		EFITOOLS= LTO= \
		COMMON_SUBDIRS='ar misc otool' \
		SUBDIRS_32= \
		RC_CFLAGS="${CFLAGS}" OFLAG="${CFLAGS}" \
		DSTROOT=\"${D}\" \
		BINDIR=\"${EPREFIX}\"${BINPATH} \
		LOCBINDIR=\"${EPREFIX}\"${BINPATH} \
		USRBINDIR=\"${EPREFIX}\"${BINPATH} \
		LOCLIBDIR=\"${EPREFIX}\"${LIBPATH} \
		MANDIR=\"${EPREFIX}\"${DATAPATH}/man/
	cd "${S}"/${CCTOOLS}/as
	emake install \
		BUILD_OBSOLETE_ARCH= \
		DSTROOT=\"${D}\" \
		USRBINDIR=\"${EPREFIX}\"${BINPATH} \
		LIBDIR=\"${EPREFIX}\"${LIBPATH} \
		LOCLIBDIR=\"${EPREFIX}\"${LIBPATH}

	cd "${ED}"${BINPATH}
	insinto ${DATAPATH}/man/man1
	local skips manpage
	# ar brings an up-to-date manpage with it
	skips=( ar )
	for bin in *; do
		for skip in ${skips[@]}; do
			if [[ ${bin} == ${skip} ]]; then
				continue 2;
			fi
		done
		manpage=${S}/${CCTOOLS}/man/${bin}.1
		if [[ -f "${manpage}" ]]; then
			doins "${manpage}"
		fi
	done
	insinto ${DATAPATH}/man/man5
	doins "${S}"/${CCTOOLS}/man/*.5
}

src_test() {
	einfo "Running unit tests"
	cd "${S}"/${LD64}/unit-tests/test-cases
	# need host arch, since GNU arch doesn't do what Apple's does
	tc-export CC CXX
	perl ../bin/make-recursive.pl \
		ARCH="$(/usr/bin/arch)" \
		RELEASEDIR="${S}"/${LD64}/src \
		| perl ../bin/result-filter.pl
}

src_install() {
	install_ld64
	install_cctools

	cd "${S}"
	insinto /etc/env.d/binutils
	cat <<-EOF > env.d
		TARGET="${CHOST}"
		VER="${PV}"
		FAKE_TARGETS="${CHOST}"
	EOF
	newins env.d ${CHOST}-${PV}
}

pkg_postinst() {
	binutils-config ${CHOST}-${PV}
}

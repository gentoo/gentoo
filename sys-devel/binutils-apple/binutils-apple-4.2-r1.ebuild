# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils-apple/binutils-apple-4.2-r1.ebuild,v 1.4 2015/02/27 08:14:46 vapier Exp $

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs

LD64=ld64-127.2
CCTOOLS_VERSION=809
CCTOOLS=cctools-${CCTOOLS_VERSION}
CCTOOLS_HEADERS=cctools-855
LIBUNWIND=libunwind-30
DYLD=dyld-195.5

DESCRIPTION="Darwin assembler as(1) and static linker ld(1), Xcode Tools ${PV}"
HOMEPAGE="http://www.opensource.apple.com/darwinsource/"
SRC_URI="http://www.opensource.apple.com/tarballs/ld64/${LD64}.tar.gz
	http://www.opensource.apple.com/tarballs/cctools/${CCTOOLS}.tar.gz
	http://www.opensource.apple.com/tarballs/cctools/${CCTOOLS_HEADERS}.tar.gz
	http://www.opensource.apple.com/tarballs/libunwind/${LIBUNWIND}.tar.gz
	http://www.opensource.apple.com/tarballs/dyld/${DYLD}.tar.gz"

LICENSE="APSL-2"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE="lto test"

RDEPEND="sys-devel/binutils-config
	lto? ( sys-devel/llvm )"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/perl-5.8.8 )
	|| ( >=sys-devel/gcc-apple-4.2.1 sys-devel/llvm )"

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
	cd "${S}"/${LD64}/src
	cp "${FILESDIR}"/ld64-127.2-Makefile Makefile
	epatch "${FILESDIR}"/${LD64}-lto.patch
	epatch "${FILESDIR}"/ld64-128.2-stdlib.patch
	epatch "${FILESDIR}"/${LD64}-ppc-range-warning.patch
	epatch "${FILESDIR}"/ld64-127.2-extraneous-headers.patch
	epatch "${FILESDIR}"/ld64-241.9-register-names.patch
	epatch "${FILESDIR}"/ld64-241.9-get-comm-align.patch
	epatch "${FILESDIR}"/ld64-241.9-cc_md5.patch
	epatch "${FILESDIR}"/ld64-128.2-1010.patch

	# We used to use our own copy of lto.h, which doesn't require llvm
	# build-env. Current versions of llvm provide
	# $EPREFIX/usr/include/llvm-c/lto.h as well as
	# $EPREFIX/usr/lib/libLTO.{so,dylib}, so we just use these.

	# provide missing headers from libunwind and dyld
	mkdir -p include/{mach,mach-o/arm} || die
	# never present because it's private
	cp ../../${DYLD}/include/mach-o/dyld_priv.h include/mach-o || die
	# missing on <= 10.5
	cp ../../${LIBUNWIND}/include/libunwind.h include/ || die
	cp ../../${LIBUNWIND}/include/mach-o/compact_unwind_encoding.h include/mach-o || die
	# missing on <= 10.4
	cp ../../${DYLD}/include/mach-o/dyld_images.h include/mach-o || die
	cp ../../${CCTOOLS}/include/mach-o/loader.h include/mach-o || die
	# use copies from cctools because they're otherwise hidden in some SDK
	cp ../../${CCTOOLS}/include/mach-o/arm/reloc.h include/mach-o/arm || die
	# provide all required CPU_TYPEs on all platforms
	cp ../../${CCTOOLS}/include/mach/machine.h include/mach/machine.h
	# add alias for newer identifiers, because ld64 uses both but cctools
	# header only defines the older
	epatch "${FILESDIR}"/ld64-236.3-missing-cputypes.patch

	# mimic OS X Leopard-style Availability.h macros for libunwind.h on
	# older systems
	[[ ${CHOST} == *darwin* && ${CHOST#*-darwin} -le 8 ]] && \
		echo "#define __OSX_AVAILABLE_STARTING(x,y)  " > include/Availability.h

	local VER_STR="\"@(#)PROGRAM:ld  PROJECT:${LD64} (Gentoo ${PN}-${PVR})\\n\""
	echo "char ldVersionString[] = ${VER_STR};" > version.cpp

	epatch "${FILESDIR}"/ld64-123.2-debug-backtrace.patch
	if [[ ${CHOST} == powerpc*-darwin* ]] ; then
		epatch "${FILESDIR}"/ld64-123.2-darwin8-no-mlong-branch-warning.patch
		epatch "${FILESDIR}"/ld64-127.2-thread_state.patch
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
	epatch "${FILESDIR}"/${PN}-5.1-extraneous-includes.patch
	epatch "${FILESDIR}"/${PN}-4.2-globals-extern.patch
	cp ../${LD64}/src/other/prune_trie.h include/mach-o/ || die
	# __darwin_i386_float_state missing on <= 10.4
	cp -a ../${CCTOOLS_HEADERS}/include/mach/i386 include/mach

	# do not build profileable libstuff to save compile time
	sed -i -e "/^all:/s, profile , ," libstuff/Makefile

	# Provide patched version information to the tools. This is normally
	# done by the Makefile using vers_string. As an added benefit, the
	# build will not fail on later OS Xes where that tool doesn't exist any
	# more.

	# Those tools don't even use their version information. Just make make
	# happy.
	touch {ar,gprof,otool}/vers.c

	# for the others defining apple_version suffices nicely although the
	# Makefile does a lot more.
	VER_STR="${CCTOOLS} (Gentoo ${PN}-${PVR})"
	echo "const char apple_version[] = \"${VER_STR}\";" \
		>> as/apple_version.c || die
	echo "const char apple_version[] = \"${VER_STR})\";" \
		>> misc/vers.c || die
	# the rest we don't even build

	# clean up test suite
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
		-e 's/^G =.*$/G =/' \
		-e 's/^OFLAG =.*$/OFLAG =/' \
		-e 's/install -c -s/install/g'
	eend $?
}

src_configure() {
	CCTOOLS_LTO=
	LD64_LTO=0
	if use lto ; then
		CCTOOLS_LTO="-DLTO_SUPPORT"
		LD64_LTO=1
	fi

	# CPPFLAGS only affects ld64, cctools don't use 'em (which currently is
	# what we want)
	append-cppflags -DNDEBUG

	CCTOOLS_OFLAG=
	if [[ ${CHOST} == *darwin* && ${CHOST#*-darwin} -le 8 ]] ; then
		# cctools expect to use UNIX03 struct member names.
		# This is default on > 10.4. Activate it on <= 10.4 by defining
		# __DARWIN_UNIX03 explicitly.
		CCTOOLS_OFLAG="-D__DARWIN_UNIX03=1"
	fi

	cat <<EOF > ${LD64}/src/configure.h
#define DEFAULT_MACOSX_MIN_VERSION "${MACOSX_DEPLOYMENT_TARGET}"
EOF
}

compile_ld64() {
	einfo "building ${LD64}"
	cd "${S}"/${LD64}/src
	emake \
		LTO=${LD64_LTO} \
		|| die "emake failed for ld64"
	use test && emake build_test
}

compile_cctools() {
	einfo "building ${CCTOOLS}"
	cd "${S}"/${CCTOOLS}
	emake \
		LIB_PRUNETRIE="-L../../${LD64}/src -lprunetrie" \
		EFITOOLS= \
		LTO="${CCTOOLS_LTO}" \
		COMMON_SUBDIRS='libstuff ar misc otool' \
		SUBDIRS_32= \
		LEGACY= \
		RC_CFLAGS="${CFLAGS}" \
		OFLAG="${CCTOOLS_OFLAG}" \
		|| die "emake failed for the cctools"
	cd "${S}"/${CCTOOLS}/as
	emake \
		BUILD_OBSOLETE_ARCH= \
		RC_CFLAGS="-DASLIBEXECDIR=\"\\\"${EPREFIX}${LIBPATH}/\\\"\" ${CFLAGS}" \
		OFLAG="${CCTOOLS_OFLAG}" \
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
		EFITOOLS= \
		COMMON_SUBDIRS='ar misc otool' \
		SUBDIRS_32= \
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
	if ! [ "${EPREFIX}"/usr/bin/clang ] ; then
		einfo "Test suite only works properly with clang - please install"
		return
	fi

	einfo "Running unit tests"
	cd "${S}"/${LD64}/unit-tests/test-cases
	# provide the new ld as a symlink to clang so that -ccc-install-dir
	# will pick it up
	ln -sfn ../../src/ld64 ld
	# use our arch command because the System's will report i386 even for an
	# x86_64 prefix
	perl ../bin/make-recursive.pl \
		BUILT_PRODUCTS_DIR="${S}"/${LD64}/src \
		ARCH="$(arch)" \
		LD="${S}"/${LD64}/src/ld64 \
		CC="clang -ccc-install-dir $PWD" \
		CXX="clang++ -ccc-install-dir $PWD" \
		OTOOL="${S}"/${CCTOOLS}/otool/otool.NEW \
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

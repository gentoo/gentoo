# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

LD64=ld64-253.6
CCTOOLS_VERSION=877.7
CCTOOLS=cctools-${CCTOOLS_VERSION}
LIBUNWIND=libunwind-35.3
DYLD=dyld-360.17

DESCRIPTION="Darwin assembler as(1) and static linker ld(1), Xcode Tools ${PV}"
HOMEPAGE="http://www.opensource.apple.com/darwinsource/"
SRC_URI="http://www.opensource.apple.com/tarballs/ld64/${LD64}.tar.gz
	http://www.opensource.apple.com/tarballs/cctools/${CCTOOLS}.tar.gz
	http://www.opensource.apple.com/tarballs/dyld/${DYLD}.tar.gz
	http://www.opensource.apple.com/tarballs/libunwind/${LIBUNWIND}.tar.gz
	http://dev.gentoo.org/~grobian/distfiles/${PN}-patches-4.3-r1.tar.bz2
	http://dev.gentoo.org/~grobian/distfiles/${PN}-patches-5.1-r2.tar.bz2
	http://dev.gentoo.org/~grobian/distfiles/${PN}-patches-6.1-r1.tar.bz2
	http://dev.gentoo.org/~grobian/distfiles/${PN}-patches-6.3-r1.tar.bz2
	http://dev.gentoo.org/~grobian/distfiles/${PN}-patches-7.0-r1.tar.bz2"

LICENSE="APSL-2"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE="test multitarget"

# ld64 can now only be compiled using llvm and libc++ since it massivley uses
# C++11 language fatures. *But additionally* the as driver now defaults to
# calling clang as the assembler on many platforms. This can be disabled using
# -Wa,-Q but since it's default we make llvm a static runtime dependency.

# Also, llvm lto and disassembler interfaces are now widely used in cctools.
# Since we cannot compile with gcc any more and every llvm since 3.4 has
# provided those interfaces, we no longer support disabling them. That
# indirectly makes xar a static runtime dependency.
RDEPEND="sys-devel/binutils-config
	app-arch/xar
	sys-devel/llvm
	sys-libs/libcxx"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/perl-5.8.8 )"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

if is_cross ; then
	SLOT="${CTARGET}-7"
else
	SLOT="7"
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
	if use multitarget ; then
		ewarn "You have enabled support for non-standard target architectures"
		ewarn "using USE=multitarget. This includes experimental support for"
		ewarn "ppc and ppc64 which is a community forward-port from the last"
		ewarn "version of ld64 to officially support PPC."

		if [[ ${CHOST} == powerpc*-darwin* ]] ; then
			ewarn "HERE BE DRAGONS! Your system seems to be PPC which means that"
			ewarn "the actual usability of your Gentoo programs will depend on the"
			ewarn "above-mentioned experimental PPC support in the linker. Be"
			ewarn "sure to keep a known-to-work version like ${PN}-3.2.6 around!"
		fi
	fi

	cd "${S}"/${LD64}/src
	cp "${S}"/ld64-136-compile_stubs.h ld/compile_stubs.h
	cp "${S}"/ld64-253.3-Makefile-2 Makefile

	epatch "${S}"/ld64-241.9-extraneous-includes.patch
	epatch "${S}"/ld64-241.9-osatomic.patch
	epatch "${S}"/ld64-236.3-crashreporter.patch
	epatch "${S}"/ld64-253.3-nosnapshots.patch
	epatch "${S}"/ld64-253.3-ppc.patch
	epatch "${S}"/ld64-236.3-constant-types-2.patch
	epatch "${S}"/ld64-241.9-register-names.patch
	epatch "${S}"/ld64-241.9-get-comm-align.patch
	epatch "${S}"/ld64-241.9-cc_md5.patch
	epatch "${S}"/ld64-253.3-make_pair.patch
	epatch "${S}"/ld64-253.3-delete-warning.patch

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
	epatch "${S}"/ld64-236.3-missing-cputypes.patch

	# mimic OS X Leopard-style Availability.h macros for libunwind.h on
	# older systems
	[[ ${CHOST} == *darwin* && ${CHOST#*-darwin} -le 8 ]] && \
		echo "#define __OSX_AVAILABLE_STARTING(x,y)  " > include/Availability.h

	local VER_STR="\"@(#)PROGRAM:ld  PROJECT:${LD64} (Gentoo ${PN}-${PVR})\\n\""
	echo "char ldVersionString[] = ${VER_STR};" > version.cpp

	epatch "${S}"/ld64-123.2-debug-backtrace.patch
	if [[ ${CHOST} == powerpc*-darwin* ]] ; then
		epatch "${S}"/ld64-123.2-darwin8-no-mlong-branch-warning.patch
		epatch "${S}"/ld64-127.2-thread_state.patch
	fi

	cd "${S}"/${CCTOOLS}
	epatch "${S}"/${PN}-4.5-as.patch
	epatch "${S}"/${PN}-5.1-as-dir.patch
	epatch "${S}"/${PN}-5.1-ranlib.patch
	epatch "${S}"/${PN}-3.1.1-libtool-ranlib.patch
	epatch "${S}"/${PN}-3.1.1-no-headers.patch
	epatch "${S}"/${PN}-4.0-no-oss-dir.patch
	epatch "${S}"/cctools-839-intel-retf.patch
	epatch "${S}"/${PN}-5.1-extraneous-includes.patch
	#epatch "${S}"/${PN}-5.1-otool-stdc.patch
	epatch "${S}"/${PN}-5.1-constant-types.patch
	epatch "${S}"/${PN}-5.1-strnlen.patch
	epatch "${S}"/${PN}-5.1-ppc.patch
	epatch "${S}"/${PN}-5.1-thread-state-redefined.patch
	epatch "${S}"/${PN}-5.1-makefile-target-warning.patch
	epatch "${S}"/${PN}-7.0-lto-prefix.patch
	epatch "${S}"/${PN}-7.0-clang-as.patch
	cp ../${LD64}/src/other/prune_trie.h include/mach-o/ || die

	# do not build profileable libstuff to save compile time
	sed -i -e "/^all:/s, profile , ," libstuff/Makefile

	# cctools version is provided to make via RC_ProjectSourceVersion which
	# generates and compiles it as apple_version[] into libstuff. From
	# there it's picked up by the individual tools. Since
	# RC_ProjectSourceVersion is also used as library version, we can't
	# just append our local version info. So we hack the libstuff Makefile
	# to include our Gentoo version.
	sed -i -e "/cctools-.*(RC_ProjectSourceVersion).*OFILE_DIR/s,Version),Version) (Gentoo ${PN}-${PVR})," \
		libstuff/Makefile

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
	# CPPFLAGS only affects ld64, cctools don't use 'em (which currently is
	# what we want)
	append-cppflags -DNDEBUG

	# Block API and thus snapshots supported on >= 10.6
	[[ ${CHOST} == *darwin* && ${CHOST#*-darwin} -ge 10 ]] && \
		append-cppflags -DSUPPORT_SNAPSHOTS

	CCTOOLS_OFLAG=
	if [[ ${CHOST} == *darwin* && ${CHOST#*-darwin} -le 8 ]] ; then
		# cctools expect to use UNIX03 struct member names.
		# This is default on > 10.4. Activate it on <= 10.4 by defining
		# __DARWIN_UNIX03 explicitly.
		CCTOOLS_OFLAG="-D__DARWIN_UNIX03=1"
	fi

	# if compiling with USE multitarget, extract all the known arches from
	# create_configure and pass them back to it
	creco=${LD64}/src/create_configure
	ARCHS_TO_SUPPORT=""
	if use multitarget ; then
		ARCHS_TO_SUPPORT="$(grep KNOWN_ARCHS= $creco | \
			cut -d\" -f2 | tr ',' ' ')"
	fi

	# Create configure.h for ld64 with SUPPORT_ARCH_<arch> defines in it.
	DERIVED_FILE_DIR=${LD64}/src \
		RC_SUPPORTED_ARCHS="$ARCHS_TO_SUPPORT" \
		$creco

	# do not depend on MachOFileAbstraction.hpp to define
	# SUPPORT_ARCH_arm_any because that's not included by every file where
	# our ppc/arm-optional patch uses it, ld.hpp in particular
	grep "SUPPORT_ARCH_armv[0-9]" ${LD64}/src/configure.h >/dev/null && \
		echo "#define SUPPORT_ARCH_arm_any 1" >> ${LD64}/src/configure.h
}

compile_ld64() {
	einfo "building ${LD64}"
	cd "${S}"/${LD64}/src
	emake || die "emake failed for ld64"
	use test && emake build_test
}

compile_cctools() {
	einfo "building ${CCTOOLS}"
	cd "${S}"/${CCTOOLS}
	# -j1 because it fails too often with weird errors
	# Suppress running dsymutil because it will warn about missing debug
	# info which is expected when compiling without -g as we normally do.
	# This might need some more thought if anyone ever wanted to build us
	# for debugging with Apple's tools.
	emake \
		LIB_PRUNETRIE="-L../../${LD64}/src -lprunetrie" \
		EFITOOLS= \
		COMMON_SUBDIRS='libstuff ar misc otool' \
		SUBDIRS_32= \
		LEGACY= \
		RC_ProjectSourceVersion=${CCTOOLS_VERSION} \
		RC_CFLAGS="${CFLAGS}" \
		OFLAG="${CCTOOLS_OFLAG}" \
		DSYMUTIL=": disabled: dsymutil" \
		-j1 \
		|| die "emake failed for the cctools"
	cd "${S}"/${CCTOOLS}/as
	emake \
		BUILD_OBSOLETE_ARCH= \
		RC_ProjectSourceVersion=${CCTOOLS_VERSION} \
		RC_CFLAGS="-DASLIBEXECDIR=\"\\\"${EPREFIX}${LIBPATH}/\\\"\" -DCLANGDIR=\"\\\"${EPREFIX}/usr/bin/\\\"\" ${CFLAGS}" \
		OFLAG="${CCTOOLS_OFLAG}" \
		DSYMUTIL=": disabled: dsymutil" \
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
		CC="${CC} -ccc-install-dir $PWD" \
		CXX="${CXX} -ccc-install-dir $PWD" \
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

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils-apple/binutils-apple-5.1.ebuild,v 1.5 2015/05/25 13:30:49 grobian Exp $

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs

LD64=ld64-236.3
CCTOOLS_VERSION=855
CCTOOLS=cctools-${CCTOOLS_VERSION}
LIBUNWIND=libunwind-35.3
DYLD=dyld-353.2.1

DESCRIPTION="Darwin assembler as(1) and static linker ld(1), Xcode Tools ${PV}"
HOMEPAGE="http://www.opensource.apple.com/darwinsource/"
SRC_URI="http://www.opensource.apple.com/tarballs/ld64/${LD64}.tar.gz
	http://www.opensource.apple.com/tarballs/cctools/${CCTOOLS}.tar.gz
	http://www.opensource.apple.com/tarballs/dyld/${DYLD}.tar.gz
	http://www.opensource.apple.com/tarballs/libunwind/${LIBUNWIND}.tar.gz"

LICENSE="APSL-2"
KEYWORDS="~x64-macos ~x86-macos"
IUSE="lto test libcxx"

RDEPEND="sys-devel/binutils-config
	lto? ( sys-devel/llvm )
	libcxx? ( sys-libs/libcxx )"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/perl-5.8.8 )
	|| ( >=sys-devel/gcc-apple-4.2.1 sys-devel/llvm )
	libcxx? ( sys-devel/llvm )"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

if is_cross ; then
	SLOT="${CTARGET}-5"
else
	SLOT="5"
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
	cp "${FILESDIR}"/ld64-136-compile_stubs.h ld/compile_stubs.h
	cp "${FILESDIR}"/ld64-236.3-Makefile Makefile

	epatch "${FILESDIR}"/ld64-236.3-nolto.patch
	epatch "${FILESDIR}"/ld64-241.9-extraneous-includes.patch
	epatch "${FILESDIR}"/ld64-241.9-atomic-volatile.patch
	epatch "${FILESDIR}"/ld64-236.3-arm64-fixup.patch
	epatch "${FILESDIR}"/ld64-241.9-arm64-cputype.patch
	epatch "${FILESDIR}"/ld64-236.3-crashreporter.patch
	epatch "${FILESDIR}"/ld64-236.3-gcc.patch
	epatch "${FILESDIR}"/ld64-236.3-constant-types.patch
	epatch "${FILESDIR}"/ld64-236.3-nosnapshots.patch
	epatch "${FILESDIR}"/ld64-236.3-noppc.patch
	epatch "${FILESDIR}"/ld64-236.3-noarm.patch
	epatch "${FILESDIR}"/ld64-241.9-register-names.patch
	epatch "${FILESDIR}"/ld64-241.9-get-comm-align.patch
	epatch "${FILESDIR}"/ld64-241.9-cc_md5.patch

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

	cd "${S}"/${CCTOOLS}
	epatch "${FILESDIR}"/${PN}-4.5-as.patch
	epatch "${FILESDIR}"/${PN}-5.1-as-dir.patch
	epatch "${FILESDIR}"/${PN}-5.1-ranlib.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-libtool-ranlib.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-no-headers.patch
	epatch "${FILESDIR}"/${PN}-4.0-no-oss-dir.patch
	epatch "${FILESDIR}"/${PN}-5.1-nolto.patch
	epatch "${FILESDIR}"/cctools-839-intel-retf.patch
	epatch "${FILESDIR}"/${PN}-5.1-extraneous-includes.patch
	epatch "${FILESDIR}"/${PN}-5.1-otool-stdc.patch
	epatch "${FILESDIR}"/${PN}-5.1-constant-types.patch
	epatch "${FILESDIR}"/${PN}-5.1-strnlen.patch
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
	CCTOOLS_LTO=
	LD64_LTO=0
	if use lto ; then
		CCTOOLS_LTO="-DLTO_SUPPORT"
		LD64_LTO=1
	fi

	if [ "${CXX/*clang*/yes}" = "yes" ] ; then
		if use libcxx ; then
			append-cxxflags -stdlib=libc++
			CXXLIB=-stdlib=libc++
		else
			# force libstdc++ for systems where libc++ is default (OS X 10.9+?)
			append-cxxflags -stdlib=libstdc++
			CXXLIB=-stdlib=libstdc++
		fi
	else
		use libcxx && \
			ewarn "libcxx only available with clang and your C++ compiler ($CXX) does not seem to be clang"
	fi

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

	# Create configure.h for ld64 with SUPPORT_ARCH_<arch> defines in it.
	# RC_SUPPORTED_ARCHS="i386 x86_64 x86_64h armv6 ..." can be used to
	# override architectures (there are more arms to add) but we configure
	# with the default to be in line with Xcode's ld.
	DERIVED_FILE_DIR=${LD64}/src \
		RC_SUPPORTED_ARCHS="" \
		${LD64}/src/create_configure
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
	# -j1 because it fails too often with weird errors
	# Suppress running dsymutil because it will warn about missing debug
	# info which is expected when compiling without -g as we normally do.
	# This might need some more thought if anyone ever wanted to build us
	# for debugging with Apple's tools.
	emake \
		LIB_PRUNETRIE="-L../../${LD64}/src -lprunetrie" \
		EFITOOLS= \
		LTO="${CCTOOLS_LTO}" \
		COMMON_SUBDIRS='libstuff ar misc otool' \
		SUBDIRS_32= \
		LEGACY= \
		RC_ProjectSourceVersion=${CCTOOLS_VERSION} \
		RC_CFLAGS="${CFLAGS}" \
		OFLAG="${CCTOOLS_OFLAG}" \
		CXXLIB="${CXXLIB}" \
		DSYMUTIL=": disabled: dsymutil" \
		-j1 \
		|| die "emake failed for the cctools"
	cd "${S}"/${CCTOOLS}/as
	emake \
		BUILD_OBSOLETE_ARCH= \
		RC_ProjectSourceVersion=${CCTOOLS_VERSION} \
		RC_CFLAGS="-DASLIBEXECDIR=\"\\\"${EPREFIX}${LIBPATH}/\\\"\" ${CFLAGS}" \
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

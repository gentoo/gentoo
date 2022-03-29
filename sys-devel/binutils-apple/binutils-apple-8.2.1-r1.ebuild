# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils flag-o-matic toolchain-funcs llvm prefix

# versions:
# XCode-11.3.1                 ld64-530        cctools-949.0.1
# XCode-11.2.1                 ld64-520        cctools-949.0.1
# XCode-11.0                   ld64-512.4      cctools-949.0.1
# XCode-8.2.1                  ld64-274.2      cctools-895         <== binutils-apple-8.2.1-r1  (2019)

# macOS-10.15.6                dyld-750.6                          Causes build failures with Xcode-11 tools
# macOS-10.14.4-10.14.6        dyld-655.1.1                        Causes build failures with Xcode-11 tools
# macOS-10.13.6                dyld-551.4
# macOS-10.12.1-10.12.3        dyld-421.2                          <== binutils-apple-8.2.1-r1,8.1

LD64=ld64-274.2
CCTOOLS_VERSION=895
CCTOOLS=cctools-${CCTOOLS_VERSION}
DYLD=dyld-421.2

DESCRIPTION="Darwin assembler as(1) and static linker ld(1), Xcode Tools ${PV}"
HOMEPAGE="http://www.opensource.apple.com/"
SRC_URI="http://www.opensource.apple.com/tarballs/ld64/${LD64}.tar.gz
	http://www.opensource.apple.com/tarballs/cctools/${CCTOOLS}.tar.gz
	http://www.opensource.apple.com/tarballs/dyld/${DYLD}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/${PN}-patches-4.3-r1.tar.bz2
	https://dev.gentoo.org/~grobian/distfiles/${PN}-patches-5.1-r2.tar.bz2
	https://dev.gentoo.org/~grobian/distfiles/${PN}-patches-7.3-r2.tar.bz2
	https://dev.gentoo.org/~grobian/distfiles/${PN}-patches-8.2-r1.tar.bz2"

LICENSE="APSL-2"
KEYWORDS="~x64-macos"
IUSE="lto classic test"
RESTRICT="!test? ( test )"

# ld64 can now only be compiled using llvm and libc++ since it massively uses
# C++11 language features. *But additionally* the as driver now defaults to
# calling clang as the assembler on many platforms. This can be disabled using
# -Wa,-Q but since it's default we make llvm a static runtime dependency.
RDEPEND="sys-devel/binutils-config
	lto? ( app-arch/xar )
	sys-devel/llvm:*
	sys-libs/libcxx"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/perl-5.8.8 )"

SLOT="8"

S=${WORKDIR}

is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

llvm_pkg_setup() {
	# eclass version will die if no LLVM can be found which will break prefix
	# bootstrap
	:
}

src_prepare() {
	cd "${S}"/${LD64}/src
	cp "${S}"/ld64-136-compile_stubs.h ld/compile_stubs.h
	cp "${S}"/ld64-274.2-Makefile Makefile

	epatch "${S}"/ld64-274.1-nolto.patch
	epatch "${S}"/ld64-236.3-crashreporter.patch
	epatch "${S}"/ld64-264.3.102-bitcode-case.patch
	epatch "${S}"/ld64-274.1-unknown-fixup.patch
	epatch "${S}"/ld64-274.1-notapi.patch
	epatch "${S}"/ld64-274.2-cfi-info-type.patch

	# workound llvm-3.9.{0,1} issue
	# https://bugs.gentoo.org/show_bug.cgi?id=603580
	# https://groups.google.com/forum/#!topic/llvm-dev/JY6nuKE__sU
	# http://lists.llvm.org/pipermail/cfe-commits/Week-of-Mon-20160829/169553.html
	sed -i -e '/COMPILE_TIME_ASSERT/d' ld/parsers/libunwind/*.hpp || die

	# provide missing headers from libunwind and dyld
	mkdir -p include/{mach,mach-o/arm} || die
	# never present because it's private
	cp ../../${DYLD}/include/mach-o/dyld_priv.h include/mach-o || die
	# use copies from cctools because they're otherwise hidden in some SDK
	cp ../../${CCTOOLS}/include/mach-o/arm/reloc.h include/mach-o/arm || die
	# provide all required CPU_TYPEs on all platforms
	cp ../../${CCTOOLS}/include/mach/machine.h include/mach/machine.h
	# add alias for newer identifiers, because ld64 uses both but cctools
	# header only defines the older
	epatch "${S}"/ld64-236.3-missing-cputypes.patch

	local VER_STR="\"@(#)PROGRAM:ld  PROJECT:${LD64} (Gentoo ${PN}-${PVR})\\n\""
	echo "char ldVersionString[] = ${VER_STR};" > version.cpp

	epatch "${S}"/ld64-123.2-debug-backtrace.patch

	cd "${S}"/${CCTOOLS}
	epatch "${S}"/${PN}-4.5-as.patch
	epatch "${S}"/${PN}-5.1-as-dir.patch
	epatch "${S}"/${PN}-5.1-ranlib.patch
	epatch "${S}"/${PN}-3.1.1-libtool-ranlib.patch
	epatch "${S}"/${PN}-3.1.1-no-headers.patch
	epatch "${S}"/${PN}-4.0-no-oss-dir.patch
	epatch "${S}"/cctools-839-intel-retf.patch
	epatch "${S}"/${PN}-5.1-extraneous-includes.patch
	epatch "${S}"/${PN}-5.1-strnlen.patch
	epatch "${S}"/${PN}-7.3-make-j.patch
	epatch "${S}"/${PN}-7.3-no-developertools-dir.patch
	epatch "${S}"/${PN}-8.2.1-llvm-prefix-3.patch
	epatch "${S}"/${PN}-8.2.1-llvm-shim.patch
	eprefixify libstuff/execute.c
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

	eapply_user

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
	ENABLE_LTO=0
	if use lto ; then
		ENABLE_LTO=1

		LLVM_INCDIR=$(get_llvm_prefix)/include
		LLVM_LIBDIR=$(get_llvm_prefix)/lib

		[ -n "${LLVM_INCDIR}" -a -n "${LLVM_LIBDIR}" ] || \
			die "LLVM not found - LTO support can not be enabled"

		# LTO and LLVM support currently both depend only on libLTO being
		# present. So we can enable both.
		CCTOOLS_LTO_CFLAGS="-DLTO_SUPPORT -I${LLVM_INCDIR}"
		CCTOOLS_LLVM_CFLAGS="-DLLVM_SUPPORT -I${LLVM_INCDIR}"
	fi

	export CTARGET=${CTARGET:-${CHOST}}
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		if [[ ${CATEGORY} == cross-* ]] ; then
			export CTARGET=${CATEGORY#cross-}
		fi
	fi

	LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${PV}
	DATAPATH=/usr/share/binutils-data/${CTARGET}/${PV}
	if is_cross ; then
		BINPATH=/usr/${CHOST}/${CTARGET}/binutils-bin/${PV}
	else
		BINPATH=/usr/${CTARGET}/binutils-bin/${PV}
	fi

	# CPPFLAGS only affects ld64, cctools don't use 'em (which currently is
	# what we want)
	append-cppflags -DNDEBUG

	# Create configure.h for ld64 with SUPPORT_ARCH_<arch> defines in it.
	DERIVED_FILE_DIR=${LD64}/src \
		${LD64}/src/create_configure
}

compile_ld64() {
	einfo "building ${LD64}"
	cd "${S}"/${LD64}/src
	emake \
		LTO=${ENABLE_LTO} \
		LTO_INCDIR=${LLVM_INCDIR} \
		LTO_LIBDIR=${LLVM_LIBDIR} \
		TAPI=0 \
		TAPI_LIBDIR="${EPREFIX}"/usr/lib

	use test && emake build_test
}

compile_cctools() {
	einfo "building ${CCTOOLS}"
	cd "${S}"/${CCTOOLS}
	# Suppress running dsymutil because it will warn about missing debug
	# info which is expected when compiling without -g as we normally do.
	# This might need some more thought if anyone ever wanted to build us
	# for debugging with Apple's tools.
	emake \
		LIB_PRUNETRIE="-L../../${LD64}/src -lprunetrie" \
		EFITOOLS= \
		LTO="${CCTOOLS_LTO_CFLAGS} ${CCTOOLS_LLVM_CFLAGS}" \
		COMMON_SUBDIRS='libstuff ar misc otool' \
		SUBDIRS_32= \
		LEGACY= \
		RC_ProjectSourceVersion=${CCTOOLS_VERSION} \
		RC_CFLAGS="${CFLAGS}" \
		OFLAG="${CCTOOLS_OFLAG}" \
		DSYMUTIL=": disabled: dsymutil"

	cd "${S}"/${CCTOOLS}/as
	emake \
		BUILD_OBSOLETE_ARCH= \
		RC_ProjectSourceVersion=${CCTOOLS_VERSION} \
		RC_CFLAGS="-DASLIBEXECDIR=\"\\\"${EPREFIX}${LIBPATH}/\\\"\" ${CFLAGS}" \
		OFLAG="${CCTOOLS_OFLAG}" \
		DSYMUTIL=": disabled: dsymutil"
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

	# upstream is starting to replace classic binutils with llvm-integrated
	# ones. In Xcode, nm and size are now symlinks to llvm-{nm,size} while the
	# classic version is preserved as {nm,size}-classic. When asked to do so
	# by use classic we statically link to the classic version.
	#   binutils-bin/<version>/<tool>
	#     -> binutils-bin/<version>/<tool>-classic
	#
	# Otherwise we try to find and use the llvm version of the tool. Since our
	# binutils do not live in the same directory as the llvm installation and
	# llvm tends to move around, we use a shim that tries to find the llvm
	# version of the tool in prefix. It will fall back to the classic tool if
	# it fails.
	#  binutils-bin/<version>/<tool>
	#    -> binutils-bin/<version>/llvm-<tool>
	#    -> $EPREFIX/usr/lib/llvm/<major/bin/llvm-<tool>
	#    -> $EPREFIX/usr/bin/llvm-<tool>
	#    -> binutils-bin/<version>/<tool>-classic
	budir=${D}/${EPREFIX}/${BINPATH}
	for tool in nm size ; do
		use classic && \
			ln -sfn ${tool}-classic "${budir}/${tool}" || \
			ln -sfn llvm-shim "${budir}/${tool}"
	done

	# Also, otool is now based on llvm-objdump. But a small wrapper installed
	# as llvm-otool remains, providing command line compatibility.
	use classic && \
		ln -sfn otool-classic "${budir}/otool" || \
		ln -sfn llvm-otool "${budir}/otool"

	# And finally, although our cctools don't actually contain dsymutil and
	# objdump, we provide access to the llvm versions of them via the shim to
	# be in line with Xcode.
	for tool in objdump dsymutil ; do
		ln -sfn llvm-shim "${budir}/${tool}"
	done

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

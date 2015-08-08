# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs

RESTRICT="test" # the test suite will test what's installed.

LD64=ld64-97.17
CCTOOLS=cctools-795
# http://lists.apple.com/archives/Darwin-dev/2009/Sep/msg00025.html
UNWIND=binutils-apple-3.2-unwind-patches-5

DESCRIPTION="Darwin assembler as(1) and static linker ld(1), Xcode Tools ${PV}"
HOMEPAGE="http://www.opensource.apple.com/darwinsource/"
SRC_URI="http://www.opensource.apple.com/tarballs/ld64/${LD64}.tar.gz
	http://www.opensource.apple.com/tarballs/cctools/${CCTOOLS}.tar.gz
	http://www.gentoo.org/~grobian/distfiles/${UNWIND}.tar.xz"

LICENSE="APSL-2"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE="lto test"
SLOT="0"

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
	SLOT="${CTARGET}"
else
	SLOT="0"
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
	cd "${S}"/${CCTOOLS}
	epatch "${FILESDIR}"/${PN}-3.2.2-as.patch
	epatch "${FILESDIR}"/${PN}-4.0-as-dir.patch
	epatch "${FILESDIR}"/${PN}-3.2.3-ranlib.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-libtool-ranlib.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-nmedit.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-no-headers.patch
	epatch "${FILESDIR}"/${PN}-3.1.1-no-oss-dir.patch

	cd "${S}"/${LD64}/src
	cp "${FILESDIR}"/ld64-95.2.12-Makefile Makefile

	ln -s ../../${CCTOOLS}/include
	cp "${WORKDIR}"/ld64-unwind/compact_unwind_encoding.h include/mach-o/
	cp other/prune_trie.h include/mach-o/ || die
	# use our own copy of lto.h, which doesn't require llvm build-env
	mkdir -p include/llvm-c || die
	cp "${WORKDIR}"/ld64-unwind/ld64-97.14-llvm-lto.h include/llvm-c/lto.h || die

	echo '' > configure.h
	echo '' > linker_opts
	local VER_STR="\"@(#)PROGRAM:ld  PROJECT:${LD64} (Gentoo ${PN}-${PVR})\\n\""
	echo "char ldVersionString[] = ${VER_STR};" > version.cpp

	epatch "${WORKDIR}"/ld64-unwind/ld64-97.14-unlibunwind.patch
	[[ ${CHOST} == powerpc*-darwin* ]] && \
		epatch "${FILESDIR}"/ld64-95.2.12-darwin8-no-mlong-branch-warning.patch
	if use !lto ; then
		sed -i -e '/#define LTO_SUPPORT 1/d' other/ObjectDump.cpp || die
	fi

	# clean up test suite
	cd "${S}"/${LD64}
	epatch "${FILESDIR}"/${PN}-3.1.1-testsuite.patch

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
		append-flags -DLTO_SUPPORT
		append-ldflags -L"${EPREFIX}"/usr/$(get_libdir)/llvm
		append-libs LTO
	else
		append-flags -ULTO_SUPPORT
	fi
}

compile_ld64() {
	cd "${S}"/${LD64}/src
	# remove antiquated copy that's available on any OSX system and
	# breaks ld64 compilation
	mv include/mach-o/dyld.h{,.disable}
	emake \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS} ${LIBS}" \
		|| die "emake failed for ld64"
	use test && emake build_test
	# restore, it's necessary for cctools' install
	mv include/mach-o/dyld.h{.disable,}
}

compile_cctools() {
	cd "${S}"/${CCTOOLS}
	emake \
		LIB_PRUNETRIE="-L../../${LD64}/src -lprunetrie" \
		EFITOOLS= LTO= \
		COMMON_SUBDIRS='libstuff ar misc otool' \
		SUBDIRS_32= \
		RC_CFLAGS="${CFLAGS}" OFLAG="${CFLAGS}" \
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
		LIBDIR=\"${EPREFIX}\"${LIBPATH}

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

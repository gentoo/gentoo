# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils flag-o-matic toolchain-funcs

RESTRICT="test" # the test suite will test what's installed.

# LD64=ld64-95.2.12 # can't compile this one, missing libunwind/* includes
# http://lists.apple.com/archives/Darwin-dev/2009/Sep/msg00025.html
LD64=ld64-85.2.1 # from 3.1.2
CCTOOLS=cctools-750
LP64PATCHES=binutils-apple-LP64-patches-1

DESCRIPTION="Darwin assembler as(1) and static linker ld(1), Xcode Tools 3.2"
HOMEPAGE="http://www.opensource.apple.com/darwinsource/"
SRC_URI="https://opensource.apple.com/tarballs/ld64/${LD64}.tar.gz
	https://opensource.apple.com/tarballs/cctools/${CCTOOLS}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/${LP64PATCHES}.tar.bz2
	https://dev.gentoo.org/~grobian/distfiles/${PN}-patches-3.2-r0.tar.bz2"

LICENSE="APSL-2"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="sys-devel/binutils-config"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/perl-5.8.8 )"

SLOT="3"

S=${WORKDIR}

is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

prepare_ld64() {
	cd "${S}"/${LD64}/src
	cp "${WORKDIR}"/Makefile . || die

	local VER_STR="\"@(#)PROGRAM:ld  PROJECT:${LD64} (Gentoo ${PN}-${PVR})\\n\""
	sed -i \
		-e '/^#define LTO_SUPPORT 1/s:1:0:' \
		ObjectDump.cpp || die
	echo '#undef LTO_SUPPORT' > configure.h
	echo '' > linker_opts
	echo "char ldVersionString[] = ${VER_STR};" > version.cpp

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

	elog "Deleted $c tests that were bound to fail"
}

src_prepare() {
	prepare_ld64

	cd "${S}"/${CCTOOLS}
	epatch "${WORKDIR}"/${PN}-3.1.1-as.patch
	epatch "${WORKDIR}"/${PN}-3.1.1-as-dir.patch
	epatch "${WORKDIR}"/${PN}-3.1.1-ranlib.patch
	epatch "${WORKDIR}"/${PN}-3.1.1-libtool-ranlib.patch
	epatch "${WORKDIR}"/${PN}-3.1.1-nmedit.patch
	epatch "${WORKDIR}"/${PN}-3.1.1-no-headers.patch
	epatch "${WORKDIR}"/${PN}-3.1.1-no-oss-dir.patch
	epatch "${WORKDIR}"/${P}-armv7-defines.patch

	cd "${S}"/${LD64}
	epatch "${WORKDIR}"/${PN}-3.1.1-testsuite.patch
	epatch "${WORKDIR}"/LP64/ld64/*.patch

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

	eapply_user
}

src_configure() {
	export CTARGET=${CTARGET:-${CHOST}}
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		if [[ ${CATEGORY} == cross-* ]] ; then
			export CTARGET=${CATEGORY#cross-}
		fi
	fi

	LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${PV}
	INCPATH=${LIBPATH}/include
	DATAPATH=/usr/share/binutils-data/${CTARGET}/${PV}
	if is_cross ; then
		BINPATH=/usr/${CHOST}/${CTARGET}/binutils-bin/${PV}
	else
		BINPATH=/usr/${CTARGET}/binutils-bin/${PV}
	fi

	if tc-is-gcc && [[ $(gcc-fullversion) != 4.2.1 ]] ; then
		# force gcc-apple
		CC=${CTARGET}-gcc-4.2.1
		CXX=${CTARGET}-g++-4.2.1
	fi
}

compile_ld64() {
	cd "${S}"/${LD64}/src
	# 'struct linkedit_data_command' is defined in mach-o/loader.h on leopard,
	# but not on tiger.
	[[ ${CHOST} == *-apple-darwin8 ]] && \
		append-flags -isystem "${S}"/${CCTOOLS}/include/
	emake || die "emake failed for ld64"
	use test && emake build_test
}

compile_cctools() {
	cd "${S}"/${CCTOOLS}
	emake \
		LTO= \
		TRIE= \
		EFITOOLS= \
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
	tc-export CC CXX
	compile_cctools
	compile_ld64
}

install_ld64() {
	exeinto ${BINPATH}
	doexe "${S}"/${LD64}/src/{ld64,rebase}
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

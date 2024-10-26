# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYP=gcc-10-${PV##*_p}-20210519-19A74-src
GNATDIR=gnat-${PV##*_p}-20210519-19A70-src
INTFDIR=gcc-interface-10-${PV##*_p}-20210519-19A75-src
BTSTRP_X86=gnat-gpl-2014-x86-linux-bin
BTSTRP_AMD64=gnat-gpl-2014-x86_64-linux-bin
BASE_URI=https://community.download.adacore.com/v1

inherit flag-o-matic toolchain-funcs

DESCRIPTION="GNAT Ada Compiler - GPL version"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="
	${BASE_URI}/005d2b2eff627177986d2517eb31e1959bec6f3a?filename=${GNATDIR}.tar.gz
		-> ${GNATDIR}.tar.gz
	${BASE_URI}/44cd393be0b468cc253bf2cf9cf7804c993e7b5b?filename=${MYP}.tar.gz
		-> ${MYP}.tar.gz
	${BASE_URI}/8ace7d06e469d36d726cc8badb0ed78411e727f3?filename=${INTFDIR}.tar.gz
		-> ${INTFDIR}.tar.gz
	amd64? (
		${BASE_URI}/6eb6eef6bb897e4c743a519bfebe0b1d6fc409c6?filename=${BTSTRP_AMD64}.tar.gz&rand=1193
		-> ${BTSTRP_AMD64}.tar.gz
	)
	x86? (
		${BASE_URI}/c5e9e6fdff5cb77ed90cf8c62536653e27c0bed6?filename=${BTSTRP_X86}.tar.gz&rand=436
		-> ${BTSTRP_X86}.tar.gz
	)
"
S="${WORKDIR}"/${MYP}

LICENSE="GPL-2 GPL-3"
SLOT="0" # TODO: slot based on GCC version used
KEYWORDS="-* amd64 x86"
RESTRICT="test"

BDEPEND="
	app-alternatives/yacc
	sys-devel/binutils:*
	>=sys-devel/flex-2.5.4
"
DEPEND="
	>=dev-libs/gmp-4.3.2:=
	>=dev-libs/mpfr-2.4.2:=
	>=dev-libs/mpc-0.8.1:=
	sys-libs/zlib
	virtual/libiconv
"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if tc-is-clang; then
		die "${P} does not build with clang. It is bootstrapped."
	fi
}

src_prepare() {
	local bundledchost
	case ${ARCH} in
		amd64)
			BTSTRP=${BTSTRP_AMD64}
			bundledchost="x86_64"
			;;
		x86)
			BTSTRP=${BTSTRP_X86}
			bundledchost="i686"
			;;
		*)
			die "Unknown \${ARCH}=${ARCH}!"
			;;
	esac

	local cleanup
	for cleanup in as ld ; do
		rm "${WORKDIR}"/${BTSTRP}/libexec/gcc/${bundledchost}-pc-linux-gnu/4.7.4/${cleanup} || die

		ln -s "${BROOT}"/usr/bin/${CHOST}-${cleanup} \
			"${WORKDIR}"/${BTSTRP}/libexec/gcc/${bundledchost}-pc-linux-gnu/4.7.4/${cleanup} || die
	done

	export GCC="${WORKDIR}"/${BTSTRP}/bin/gcc

	gnatbase=$(basename ${GCC})
	gnatpath=$(dirname ${GCC})
	export GNATMAKE=${gnatbase/gcc/gnatmake}
	if [[ ${gnatpath} != "." ]] ; then
		GNATMAKE="${gnatpath}/${GNATMAKE}"
	fi

	export CC=${GCC}
	export CXX="${gnatbase/gcc/g++}"
	export GNATBIND="${gnatbase/gcc/gnatbind}"
	export GNATLINK="${gnatbase/gcc/gnatlink}"
	export GNATLS="${gnatbase/gcc/gnatls}"
	if [[ ${gnatpath} != "." ]] ; then
		CXX="${gnatpath}/${CXX}"
		GNATBIND="${gnatpath}/${GNATBIND}"
		GNATLINK="${gnatpath}/${GNATLINK}"
		GNATLS="${gnatpath}/${GNATLS}"
	fi

	mkdir bin || die
	local tool
	for tool in gnat{make,bind,link,ls} ; do
		ln -s $(type -P ${tool^^}) bin/${tool} || die
		ln -s $(type -P ${tool^^}) bin/${bundledchost}-pc-linux-gnu-${tool} || die
	done
	ln -s $(type -P ${GCC}) bin/gcc || die
	ln -s $(type -P ${GCC}) bin/${bundledchost}-pc-linux-gnu-gcc || die
	ln -s $(type -P ${CXX}) bin/g++ || die
	ln -s $(type -P ${CXX}) bin/${bundledchost}-pc-linux-gnu-g++ || die

	cd .. || die
	mv ${GNATDIR}/src/ada ${MYP}/gcc/ || die
	mv ${INTFDIR} ${MYP}/gcc/ada/gcc-interface || die
	eapply "${FILESDIR}"/${P}-gentoo.patch
	cd - || die

	sed -i \
		-e 's:-fcf-protection":":' \
		libiberty/configure \
		lto-plugin/configure || die
	sed -i \
		-e 's:$(P) ::g' \
		gcc/ada/gcc-interface/Makefile.in \
		|| die "sed failed"
	default
}

src_configure() {
	local adabdir=/usr/lib/${PN}
	local prefix=${EPREFIX}${adabdir}

	export PATH="${WORKDIR}"/${BTSTRP}/bin:"${WORKDIR}"/${GNATDIR}/bin:${PWD}/bin:${PATH}

	# This version is GCC 4.7.4 with a bolted-on newer GNAT; be very
	# conservative, we just want it to build for bootstrapping proper
	# sys-devel/gcc[ada]. We don't need it to be fast.
	strip-flags
	CC="${WORKDIR}"/${BTSTRP}/bin/gcc strip-unsupported-flags
	CC="${WORKDIR}"/${GNATDIR}/bin/gcc strip-unsupported-flags
	strip-unsupported-flags
	filter-lto
	append-flags -O2
	append-flags -fno-strict-aliasing

	local conf=(
		--{doc,info,man}dir=/.skip # let the real gcc handle docs
		MAKEINFO=: #922230
		--prefix="${prefix}"
		--disable-analyzer
		--disable-bootstrap
		--disable-cc1
		--disable-cet
		--disable-gcov #843989
		--disable-gomp
		--disable-objc-gc
		--disable-nls # filename collisions
		--disable-libcc1
		--disable-libgomp
		--disable-libitm
		--disable-libquadmath
		--disable-libsanitizer
		--disable-libssp
		--disable-libstdcxx-pch
		--disable-libvtv
		--disable-shared
		--disable-werror
		--enable-languages=ada
		--with-gcc-major-version-only
		--with-system-zlib
		--without-isl
		--without-python-dir
		--without-zstd
		--disable-multilib
	)

	# libstdc++ may misdetect sys/sdt.h on systemtap-enabled system and fail
	# (not passed in conf_gcc above given it is lost in sub-configure calls)
	local -x glibcxx_cv_sys_sdt_h=no

	mkdir "${WORKDIR}"/build || die
	cd "${WORKDIR}"/build
	ECONF_SOURCE="${S}" econf "${conf[@]}"
}

src_compile() {
	emake -C "${WORKDIR}"/build MAKEINFO=: V=1
}

src_install() {
	# -j1 to match bug #906155, other packages may be fragile too
	emake -C "${WORKDIR}"/build -j1 MAKEINFO=: V=1 DESTDIR="${D}" install

	# Make `gcc-config`-style symlinks
	local tool
	cd "${ED}"/usr/lib/ada-bootstrap/bin || die
	for tool in gnat{,bind,chop,clean,kr,link,ls,make,name,prep} ; do
		ln -s ${tool} ${CBUILD}-${tool} || die
		ln -s ${tool} ${CBUILD}-${tool}-10 || die
	done

	# Delete libdep.a, which has a colliding name and is useless for bpf,
	# which does not make use of cross-library dependencies: the libdep.a
	# for the native binutils will do.
	rm -f "${ED}"/${adabdir}/lib/bfd-plugins/libdep.a || die
}

# TODO: pkg_postinst warning/log?

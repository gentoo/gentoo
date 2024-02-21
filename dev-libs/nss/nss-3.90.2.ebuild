# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib toolchain-funcs multilib-minimal

NSPR_VER="4.35"
RTM_NAME="NSS_${PV//./_}_RTM"

DESCRIPTION="Mozilla's Network Security Services library that implements PKI support"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS"
SRC_URI="https://archive.mozilla.org/pub/security/nss/releases/${RTM_NAME}/src/${P}.tar.gz
	cacert? ( https://dev.gentoo.org/~whissi/dist/ca-certificates/nss-cacert-class1-class3-r2.patch )"

LICENSE="|| ( MPL-2.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="cacert test +utils cpu_flags_ppc_altivec cpu_flags_x86_avx2 cpu_flags_x86_sse3 cpu_flags_ppc_vsx"
RESTRICT="!test? ( test )"
# pkg-config called by nss-config -> virtual/pkgconfig in RDEPEND
RDEPEND="
	>=dev-libs/nspr-${NSPR_VER}[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	virtual/pkgconfig
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/perl"

S="${WORKDIR}/${P}/${PN}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/nss-config
)

PATCHES=(
	"${FILESDIR}/${PN}-3.53-gentoo-fixups.patch"
	"${FILESDIR}/${PN}-3.21-gentoo-fixup-warnings.patch"
	"${FILESDIR}"/nss-3.87-use-clang-as-bgo892686.patch
)

src_prepare() {
	default

	if use cacert ; then
		eapply -p2 "${DISTDIR}"/nss-cacert-class1-class3-r2.patch
	fi

	pushd coreconf >/dev/null || die
	# hack nspr paths
	echo 'INCLUDES += -I$(DIST)/include/dbm' \
		>> headers.mk || die "failed to append include"

	# modify install path
	sed -e '/CORE_DEPTH/s:SOURCE_PREFIX.*$:SOURCE_PREFIX = $(CORE_DEPTH)/dist:' \
		-i source.mk || die

	# Respect LDFLAGS
	sed -i -e 's/\$(MKSHLIB) -o/\$(MKSHLIB) \$(LDFLAGS) -o/g' rules.mk

	# Workaround make-4.4's change to sub-make, bmo#1800237, bgo#882069
	sed -i -e "s/^CPU_TAG = _.*/CPU_TAG = _$(nssarch)/" Linux.mk || die

	popd >/dev/null || die

	# Fix pkgconfig file for Prefix
	sed -i -e "/^PREFIX =/s:= /usr:= ${EPREFIX}/usr:" \
		config/Makefile || die

	# use host shlibsign if need be #436216
	if tc-is-cross-compiler ; then
		sed -i \
			-e 's:"${2}"/shlibsign:shlibsign:' \
			cmd/shlibsign/sign.sh || die
	fi

	# dirty hack
	sed -i -e "/CRYPTOLIB/s:\$(SOFTOKEN_LIB_DIR):../freebl/\$(OBJDIR):" \
		lib/ssl/config.mk || die
	sed -i -e "/CRYPTOLIB/s:\$(SOFTOKEN_LIB_DIR):../../lib/freebl/\$(OBJDIR):" \
		cmd/platlibs.mk || die

	multilib_copy_sources

	strip-flags
}

multilib_src_configure() {
	# Ensure we stay multilib aware
	sed -i -e "/@libdir@/ s:lib64:$(get_libdir):" config/Makefile || die
}

nssarch() {
	# Most of the arches are the same as $ARCH
	local t=${1:-${CHOST}}
	case ${t} in
		*86*-pc-solaris2*) echo "i86pc"   ;;
		aarch64*)          echo "aarch64" ;;
		hppa*)             echo "parisc"  ;;
		i?86*)             echo "i686"    ;;
		x86_64*)           echo "x86_64"  ;;
		*)                 tc-arch ${t}   ;;
	esac
}

nssbits() {
	local cc cppflags="${1}CPPFLAGS" cflags="${1}CFLAGS"
	if [[ ${1} == BUILD_ ]]; then
		cc=$(tc-getBUILD_CC)
	else
		cc=$(tc-getCC)
	fi
	# TODO: Port this to toolchain-funcs tc-get-ptr-size/tc-get-build-ptr-size
	echo > "${T}"/test.c || die
	${cc} ${!cppflags} ${!cflags} -fno-lto -c "${T}"/test.c -o "${T}/${1}test.o" || die
	case $(file -S "${T}/${1}test.o") in
		*32-bit*x86-64*) echo USE_X32=1;;
		*64-bit*|*ppc64*|*x86_64*) echo USE_64=1;;
		*32-bit*|*ppc*|*i386*) ;;
		*) die "Failed to detect whether ${cc} builds 64bits or 32bits, disable distcc if you're using it, please";;
	esac
}

multilib_src_compile() {
	# use ABI to determine bit'ness, or fallback if unset
	local buildbits mybits
	case "${ABI}" in
		n32) mybits="USE_N32=1";;
		x32) mybits="USE_X32=1";;
		s390x|*64) mybits="USE_64=1";;
		${DEFAULT_ABI})
			einfo "Running compilation test to determine bit'ness"
			mybits=$(nssbits)
			;;
	esac
	# bitness of host may differ from target
	if tc-is-cross-compiler; then
		buildbits=$(nssbits BUILD_)
	fi

	local makeargs=(
		CC="$(tc-getCC)"
		CCC="$(tc-getCXX)"
		AR="$(tc-getAR) rc \$@"
		RANLIB="$(tc-getRANLIB)"
		OPTIMIZER=
		${mybits}
		disable_ckbi=0
	)

	# Take care of nspr settings #436216
	local myCPPFLAGS="${CPPFLAGS} $($(tc-getPKG_CONFIG) nspr --cflags)"
	unset NSPR_INCLUDE_DIR

	export NSS_ALLOW_SSLKEYLOGFILE=1
	export NSS_ENABLE_WERROR=0 #567158
	export BUILD_OPT=1
	export NSS_USE_SYSTEM_SQLITE=1
	export NSDISTMODE=copy
	export FREEBL_NO_DEPEND=1
	export FREEBL_LOWHASH=1
	export NSS_SEED_ONLY_DEV_URANDOM=1
	export USE_SYSTEM_ZLIB=1
	export ZLIB_LIBS=-lz
	export ASFLAGS=""
	# Fix build failure on arm64
	export NS_USE_GCC=1
	# Detect compiler type and set proper environment value
	if tc-is-gcc; then
		export CC_IS_GCC=1
	elif tc-is-clang; then
		export CC_IS_CLANG=1
	fi

	export NSS_DISABLE_GTESTS=$(usex !test 1 0)

	# Include exportable custom settings defined by users, #900915
	# Two examples uses:
	#   EXTRA_NSSCONF="MYONESWITCH=1"
	#   EXTRA_NSSCONF="MYVALUE=0 MYOTHERVALUE=1 MYTHIRDVALUE=1"
	# e.g.
	#   EXTRA_NSSCONF="NSS_ALLOW_SSLKEYLOGFILE=0"
	# or
	#   EXTRA_NSSCONF="NSS_ALLOW_SSLKEYLOGFILE=0 NSS_ENABLE_WERROR=1"
	# etc.
	if [[ -n "${EXTRA_NSSCONF}" ]]; then
		ewarn "EXTRA_NSSCONF applied, please disable custom settings before reporting bugs."
		read -a myextranssconf <<< "${EXTRA_NSSCONF}"

		for (( i=0; i<${#myextranssconf[@]}; i++ )); do
			export "${myextranssconf[$i]}"
			echo "exported ${myextranssconf[$i]}"
		done
	fi

	# explicitly disable altivec/vsx if not requested
	# https://bugs.gentoo.org/789114
	case ${ARCH} in
		ppc*)
			use cpu_flags_ppc_altivec || export NSS_DISABLE_ALTIVEC=1
			use cpu_flags_ppc_vsx || export NSS_DISABLE_CRYPTO_VSX=1
			;;
	esac

	use cpu_flags_x86_avx2 || export NSS_DISABLE_AVX2=1
	use cpu_flags_x86_sse3 || export NSS_DISABLE_SSE3=1

	local d

	# Build the host tools first.
	LDFLAGS="${BUILD_LDFLAGS}" \
	XCFLAGS="${BUILD_CFLAGS}" \
	NSPR_LIB_DIR="${T}/fakedir" \
	emake -C coreconf \
		CC="$(tc-getBUILD_CC)" \
			${buildbits-${mybits}}
	makeargs+=( NSINSTALL="${PWD}/$(find -type f -name nsinstall)" )

	# Then build the target tools.
	for d in . lib/dbm ; do
		CPPFLAGS="${myCPPFLAGS}" \
		XCFLAGS="${CFLAGS} ${CPPFLAGS}" \
		NSPR_LIB_DIR="${T}/fakedir" \
		emake "${makeargs[@]}" -C ${d} OS_TEST="$(nssarch)"
	done
}

multilib_src_test() {
	einfo "Tests can take a *long* time, especially on a multilib system."
	einfo "30-45+ minutes per lib configuration. Bug #852755"

	# https://www.linuxfromscratch.org/blfs/view/svn/postlfs/nss.html
	# https://firefox-source-docs.mozilla.org/security/nss/legacy/nss_sources_building_testing/index.html#running_the_nss_test_suite
	# https://www-archive.mozilla.org/projects/security/pki/nss/testnss_32.html (older)
	export BUILD_OPT=1
	export HOST="localhost"
	export DOMSUF="localdomain"
	export USE_IP=TRUE
	export IP_ADDRESS="127.0.0.1"

	# Only run the standard cycle instead of full, reducing testing time from 45 minutes to 15
	# per lib implementation.
	export NSS_CYCLES=standard

	NSINSTALL="${PWD}/$(find -type f -name nsinstall)"

	cd "${BUILD_DIR}"/tests || die
	# Hack to get current objdir (prefixed dir where built binaries are)
	# Without this, at least multilib tests go wrong when building the amd64 variant
	# after x86.
	local objdir=$(find "${BUILD_DIR}"/dist -maxdepth 1 -iname Linux* | rev | cut -d/ -f1 | rev)

	# Can tweak to a subset of tests in future if we need to, but would prefer not
	OBJDIR="${objdir}" DIST="${BUILD_DIR}/dist" MOZILLA_ROOT="${BUILD_DIR}" ./all.sh || die
}

# Altering these 3 libraries breaks the CHK verification.
# All of the following cause it to break:
# - stripping
# - prelink
# - ELF signing
# http://www.mozilla.org/projects/security/pki/nss/tech-notes/tn6.html
# Either we have to NOT strip them, or we have to forcibly resign after
# stripping.
#local_libdir="$(get_libdir)"
#export STRIP_MASK="
#	*/${local_libdir}/libfreebl3.so*
#	*/${local_libdir}/libnssdbm3.so*
#	*/${local_libdir}/libsoftokn3.so*"

export NSS_CHK_SIGN_LIBS="freebl3 nssdbm3 softokn3"

generate_chk() {
	local shlibsign="$1"
	local libdir="$2"
	einfo "Resigning core NSS libraries for FIPS validation"
	shift 2
	local i
	for i in ${NSS_CHK_SIGN_LIBS} ; do
		local libname=lib${i}.so
		local chkname=lib${i}.chk
		"${shlibsign}" \
			-i "${libdir}"/${libname} \
			-o "${libdir}"/${chkname}.tmp \
		&& mv -f \
			"${libdir}"/${chkname}.tmp \
			"${libdir}"/${chkname} \
		|| die "Failed to sign ${libname}"
	done
}

cleanup_chk() {
	local libdir="$1"
	shift 1
	local i
	for i in ${NSS_CHK_SIGN_LIBS} ; do
		local libfname="${libdir}/lib${i}.so"
		# If the major version has changed, then we have old chk files.
		[ ! -f "${libfname}" -a -f "${libfname}.chk" ] \
			&& rm -f "${libfname}.chk"
	done
}

multilib_src_install() {
	pushd dist >/dev/null || die

	dodir /usr/$(get_libdir)
	cp -L */lib/*$(get_libname) "${ED}"/usr/$(get_libdir) || die "copying shared libs failed"
	local i
	for i in crmf freebl nssb nssckfw ; do
		cp -L */lib/lib${i}.a "${ED}"/usr/$(get_libdir) || die "copying libs failed"
	done

	# Install nss-config and pkgconfig file
	dodir /usr/bin
	cp -L */bin/nss-config "${ED}"/usr/bin || die
	dodir /usr/$(get_libdir)/pkgconfig
	cp -L */lib/pkgconfig/nss.pc "${ED}"/usr/$(get_libdir)/pkgconfig || die

	# create an nss-softokn.pc from nss.pc for libfreebl and some private headers
	# bug 517266
	sed 	-e 's#Libs:#Libs: -lfreebl#' \
		-e 's#Cflags:#Cflags: -I${includedir}/private#' \
		*/lib/pkgconfig/nss.pc >"${ED}"/usr/$(get_libdir)/pkgconfig/nss-softokn.pc \
		|| die "could not create nss-softokn.pc"

	# all the include files
	insinto /usr/include/nss
	doins public/nss/*.{h,api}
	insinto /usr/include/nss/private
	doins private/nss/{blapi,alghmac,cmac}.h

	popd >/dev/null || die

	local f nssutils
	# Always enabled because we need it for chk generation.
	nssutils=( shlibsign )

	if multilib_is_native_abi ; then
		if use utils; then
			# The tests we do not need to install.
			#nssutils_test="bltest crmftest dbtest dertimetest
			#fipstest remtest sdrtest"
			# checkcert utils has been removed in nss-3.22:
			# https://bugzilla.mozilla.org/show_bug.cgi?id=1187545
			# https://hg.mozilla.org/projects/nss/rev/df1729d37870
			# certcgi has been removed in nss-3.36:
			# https://bugzilla.mozilla.org/show_bug.cgi?id=1426602
			nssutils+=(
				addbuiltin
				atob
				baddbdir
				btoa
				certutil
				cmsutil
				conflict
				crlutil
				derdump
				digest
				makepqg
				mangle
				modutil
				multinit
				nonspr10
				ocspclnt
				oidcalc
				p7content
				p7env
				p7sign
				p7verify
				pk11mode
				pk12util
				pp
				rsaperf
				selfserv
				signtool
				signver
				ssltap
				strsclnt
				symkeyutil
				tstclnt
				vfychain
				vfyserv
			)
			# install man-pages for utils (bug #516810)
			doman doc/nroff/*.1
		fi
		pushd dist/*/bin >/dev/null || die
		for f in ${nssutils[@]}; do
			dobin ${f}
		done
		popd >/dev/null || die
	fi
}

pkg_postinst() {
	multilib_pkg_postinst() {
		# We must re-sign the libraries AFTER they are stripped.
		local shlibsign="${EROOT}/usr/bin/shlibsign"
		# See if we can execute it (cross-compiling & such). #436216
		"${shlibsign}" -h >&/dev/null
		if [[ $? -gt 1 ]] ; then
			shlibsign="shlibsign"
		fi
		generate_chk "${shlibsign}" "${EROOT}"/usr/$(get_libdir)
	}

	multilib_foreach_abi multilib_pkg_postinst
}

pkg_postrm() {
	multilib_pkg_postrm() {
		cleanup_chk "${EROOT}"/usr/$(get_libdir)
	}

	multilib_foreach_abi multilib_pkg_postrm
}

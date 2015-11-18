# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs multilib-minimal

NSPR_VER="4.10.8"
RTM_NAME="NSS_${PV//./_}_RTM"
# Rev of https://git.fedorahosted.org/cgit/nss-pem.git
PEM_GIT_REV="015ae754dd9f6fbcd7e52030ec9732eb27fc06a8"
PEM_P="${PN}-pem-${PEM_GIT_REV}"

DESCRIPTION="Mozilla's Network Security Services library that implements PKI support"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/nss/"
SRC_URI="http://archive.mozilla.org/pub/mozilla.org/security/nss/releases/${RTM_NAME}/src/${P}.tar.gz
	cacert? ( https://dev.gentoo.org/~anarchy/patches/${PN}-3.14.1-add_spi+cacerts_ca_certs.patch )
	nss-pem? ( https://git.fedorahosted.org/cgit/nss-pem.git/snapshot/${PEM_P}.tar.bz2 )"

LICENSE="|| ( MPL-2.0 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cacert +nss-pem utils"
CDEPEND=">=dev-db/sqlite-3.8.2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND=">=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/nspr-${NSPR_VER}[${MULTILIB_USEDEP}]
	${CDEPEND}"
RDEPEND=">=dev-libs/nspr-${NSPR_VER}[${MULTILIB_USEDEP}]
	${CDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r12
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

RESTRICT="test"

S="${WORKDIR}/${P}/${PN}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/nss-config
)

src_unpack() {
	unpack ${A}
	if use nss-pem ; then
		mv "${PEM_P}"/nss/lib/ckfw/pem/ "${S}"/lib/ckfw/ || die
	fi
}

src_prepare() {
	# Custom changes for gentoo
	epatch "${FILESDIR}/${PN}-3.17.1-gentoo-fixups.patch"
	epatch "${FILESDIR}/${PN}-3.15-gentoo-fixup-warnings.patch"
	use cacert && epatch "${DISTDIR}/${PN}-3.14.1-add_spi+cacerts_ca_certs.patch"
	use nss-pem && epatch "${FILESDIR}/${PN}-3.15.4-enable-pem.patch"
	epatch "${FILESDIR}/nss-3.14.2-solaris-gcc.patch"
	epatch "${FILESDIR}/${PN}-cacert-class3.patch" # 521462

	pushd coreconf >/dev/null || die
	# hack nspr paths
	echo 'INCLUDES += -I$(DIST)/include/dbm' \
		>> headers.mk || die "failed to append include"

	# modify install path
	sed -e '/CORE_DEPTH/s:SOURCE_PREFIX.*$:SOURCE_PREFIX = $(CORE_DEPTH)/dist:' \
		-i source.mk || die

	# Respect LDFLAGS
	sed -i -e 's/\$(MKSHLIB) -o/\$(MKSHLIB) \$(LDFLAGS) -o/g' rules.mk
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
		aarch64*)echo "aarch64";;
		hppa*)   echo "parisc";;
		i?86*)   echo "i686";;
		x86_64*) echo "x86_64";;
		*)       tc-arch ${t};;
	esac
}

nssbits() {
	local cc cppflags="${1}CPPFLAGS" cflags="${1}CFLAGS"
	if [[ ${1} == BUILD_ ]]; then
		cc=$(tc-getBUILD_CC)
	else
		cc=$(tc-getCC)
	fi
	echo > "${T}"/test.c || die
	${cc} ${!cppflags} ${!cflags} -c "${T}"/test.c -o "${T}/${1}test.o" || die
	case $(file "${T}/${1}test.o") in
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
		AR="$(tc-getAR) rc \$@"
		RANLIB="$(tc-getRANLIB)"
		OPTIMIZER=
		${mybits}
	)

	# Take care of nspr settings #436216
	local myCPPFLAGS="${CPPFLAGS} $($(tc-getPKG_CONFIG) nspr --cflags)"
	unset NSPR_INCLUDE_DIR

	# Do not let `uname` be used.
	if use kernel_linux ; then
		makeargs+=(
			OS_TARGET=Linux
			OS_RELEASE=2.6
			OS_TEST="$(nssarch)"
		)
	fi

	export BUILD_OPT=1
	export NSS_USE_SYSTEM_SQLITE=1
	export NSDISTMODE=copy
	export NSS_ENABLE_ECC=1
	export FREEBL_NO_DEPEND=1
	export ASFLAGS=""

	local d

	# Build the host tools first.
	LDFLAGS="${BUILD_LDFLAGS}" \
	XCFLAGS="${BUILD_CFLAGS}" \
	NSPR_LIB_DIR="${T}/fakedir" \
	emake -j1 -C coreconf \
		CC="$(tc-getBUILD_CC)" \
		${buildbits:-${mybits}}
	makeargs+=( NSINSTALL="${PWD}/$(find -type f -name nsinstall)" )

	# Then build the target tools.
	for d in . lib/dbm ; do
		CPPFLAGS="${myCPPFLAGS}" \
		XCFLAGS="${CFLAGS} ${CPPFLAGS}" \
		NSPR_LIB_DIR="${T}/fakedir" \
		emake -j1 "${makeargs[@]}" -C ${d}
	done
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
	cp -L */lib/libcrmf.a "${ED}"/usr/$(get_libdir) || die "copying libs failed"
	cp -L */lib/libfreebl.a "${ED}"/usr/$(get_libdir) || die "copying libs failed"

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
	doins public/nss/*.h
	insinto /usr/include/nss/private
	doins private/nss/{blapi,alghmac}.h

	popd >/dev/null || die

	local f nssutils
	# Always enabled because we need it for chk generation.
	nssutils="shlibsign"

	if multilib_is_native_abi ; then
		if use utils; then
			# The tests we do not need to install.
			#nssutils_test="bltest crmftest dbtest dertimetest
			#fipstest remtest sdrtest"
			nssutils="addbuiltin atob baddbdir btoa certcgi certutil checkcert
			cmsutil conflict crlutil derdump digest makepqg mangle modutil multinit
			nonspr10 ocspclnt oidcalc p7content p7env p7sign p7verify pk11mode
			pk12util pp rsaperf selfserv shlibsign signtool signver ssltap strsclnt
			symkeyutil tstclnt vfychain vfyserv"
			# install man-pages for utils (bug #516810)
			doman doc/nroff/*.1
		fi
		pushd dist/*/bin >/dev/null || die
		for f in ${nssutils}; do
			dobin ${f}
		done
		popd >/dev/null || die
	fi

	# Prelink breaks the CHK files. We don't have any reliable way to run
	# shlibsign after prelink.
	local l libs=() liblist
	for l in ${NSS_CHK_SIGN_LIBS} ; do
		libs+=("${EPREFIX}/usr/$(get_libdir)/lib${l}.so")
	done
	liblist=$(printf '%s:' "${libs[@]}")
	echo -e "PRELINK_PATH_MASK=${liblist%:}" > "${T}/90nss-${ABI}"
	doenvd "${T}/90nss-${ABI}"
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

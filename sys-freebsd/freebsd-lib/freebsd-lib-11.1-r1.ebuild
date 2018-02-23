# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit bsdmk freebsd flag-o-matic multilib toolchain-funcs eutils multibuild multilib-build

DESCRIPTION="FreeBSD's base system libraries"
SLOT="0"
LICENSE="BSD GPL-2 zfs? ( CDDL )"

# Security Advisory and Errata patches.
# UPSTREAM_PATCHES=()

# Crypto is needed to have an internal OpenSSL header
# sys is needed for libalias, probably we can just extract that instead of
# extracting the whole tarball
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~x86-fbsd"
	SRC_URI="${SRC_URI}
			$(freebsd_upstream_patches)"
fi

EXTRACTONLY="
	lib/
	contrib/
	crypto/
	libexec/
	etc/
	include/
	usr.bin/
	usr.sbin/
	gnu/
	secure/
"

if [ "${CATEGORY#*cross-}" = "${CATEGORY}" ]; then
	RDEPEND="ssl? ( dev-libs/openssl:0= )
		hesiod? ( net-dns/hesiod )
		kerberos? ( app-crypt/heimdal )
		pam? ( virtual/pam )
		usb? ( !dev-libs/libusb )
		zfs? ( =sys-freebsd/freebsd-cddl-${RV}* )
		>=dev-libs/expat-2.0.1
		>=dev-util/dialog-1.2.20150225
		!sys-freebsd/freebsd-libexec
		!sys-libs/libutempter
		!dev-libs/libelf
		!dev-libs/libexecinfo
		!dev-libs/libiconv
		!sys-freebsd/freebsd-headers"
	DEPEND="${RDEPEND}
		>=sys-devel/flex-2.5.31-r2
		=sys-freebsd/freebsd-sources-${RV}*"
	RDEPEND="${RDEPEND}
		=sys-freebsd/freebsd-share-${RV}*
		xinetd? ( sys-apps/xinetd )
		>=virtual/libiconv-0-r2"
else
	EXTRACTONLY+="sys/ "
fi

DEPEND="${DEPEND}
		userland_GNU? ( sys-apps/mtree )
		=sys-freebsd/freebsd-mk-defs-${RV}*"

S="${WORKDIR}/lib"

export CTARGET=${CTARGET:-${CHOST}}
if [ "${CTARGET}" = "${CHOST}" -a "${CATEGORY#*cross-}" != "${CATEGORY}" ]; then
	export CTARGET=${CATEGORY/cross-}
fi

IUSE="atm bluetooth ssl hesiod ipv6 kerberos usb netware
	build headers-only zfs pam xinetd
	userland_GNU userland_BSD"

QA_DT_NEEDED="lib/libc.so.7 usr/lib32/libc.so.7"

pkg_setup() {
	# Add the required source files.
	use build && EXTRACTONLY+="sys/ "
	use zfs && EXTRACTONLY+="cddl/ "

	[ -c /dev/zero ] || \
		die "You forgot to mount /dev; the compiled libc would break."

	if ! use ssl && use kerberos; then
		eerror "If you want kerberos support you need to enable ssl support, too."
	fi

	use atm || mymakeopts="${mymakeopts} WITHOUT_ATM= "
	use bluetooth || mymakeopts="${mymakeopts} WITHOUT_BLUETOOTH= "
	use hesiod || mymakeopts="${mymakeopts} WITHOUT_HESIOD= "
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6_SUPPORT= "
	use kerberos || mymakeopts="${mymakeopts} WITHOUT_KERBEROS_SUPPORT= WITHOUT_GSSAPI= "
	use netware || mymakeopts="${mymakeopts} WITHOUT_IPX= WITHOUT_IPX_SUPPORT= WITHOUT_NCP= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL= "
	use usb || mymakeopts="${mymakeopts} WITHOUT_USB= "
	use zfs || mymakeopts="${mymakeopts} WITHOUT_CDDL= "

	mymakeopts="${mymakeopts} WITHOUT_SENDMAIL= WITHOUT_CLANG= WITHOUT_LIBCPLUSPLUS= WITHOUT_LDNS= WITHOUT_UNBOUND= WITHOUT_BSNMP= "

	if [ "${CTARGET}" != "${CHOST}" ]; then
		mymakeopts="${mymakeopts} MACHINE=$(tc-arch-kernel ${CTARGET})"
		mymakeopts="${mymakeopts} MACHINE_ARCH=$(tc-arch-kernel ${CTARGET})"
	fi

	# Taken from freebsd-libexec.
	use pam || mymakeopts="${mymakeopts} WITHOUT_PAM_SUPPORT= "
	if has_version "<sys-freebsd/freebsd-ubin-11.0"; then
		mymakeopts="${mymakeopts} WITHOUT_MAN_UTILS= "
	fi
}

PATCHES=(
	"${FILESDIR}/${PN}-6.0-pmc.patch"
	"${FILESDIR}/${PN}-9.0-bluetooth.patch"
	"${FILESDIR}/${PN}-11.0-workaround.patch"
	"${FILESDIR}/${PN}-11.0-bsdxml2expat.patch"
	"${FILESDIR}/${PN}-11.0-libproc-libcxx.patch"
	"${FILESDIR}/${PN}-11.1-liblink.patch"
	"${FILESDIR}/${PN}-add-nossp-cflags.patch"
	)
# Here we disable and remove source which we don't need or want
# In order:
# - ncurses stuff
# - libexpat creates a bsdxml library which is the same as expat
# - archiving libraries (have their own ebuild)
# - sendmail libraries (they are installed by sendmail)
# - SNMP library and dependency (have their own ebuilds)
# - libstand: static library, 32bits on amd64 used for boot0, we build it from
# boot0 instead.
#
# The rest are libraries we already have somewhere else because
# they are contribution.
REMOVE_SUBDIRS="ncurses \
	libexpat \
	libz libbz2 libarchive liblzma \
	libsm libsmdb libsmutil \
	libbegemot libbsnmp \
	libpam libpcap libwrap libmagic \
	libcom_err
	libedit
	libstand
	libgssapi"

# Are we building a cross-compiler?
is_crosscompile() {
	[ "${CATEGORY#*cross-}" != "${CATEGORY}" ]
}

src_prepare() {
	# If gcc-5.0 or later, apply a workaround to fix a critical issue. bug 573358
	[[ "$(gcc-major-version)" -ge 5 ]] && replace-flags -O? -O1

	sed -i.bak -e 's:-o/dev/stdout:-t:' "${S}/libc/net/Makefile.inc"

	# Upstream Display Managers default to using VT7
	# We should make FreeBSD allow this by default
	local x=
	for x in "${WORKDIR}"/etc/etc.*/ttys ; do
		sed -i.bak \
			-e '/ttyv5[[:space:]]/ a\
# Display Managers default to VT7.\
# If you use the xdm init script, keep ttyv6 commented out\
# unless you force a different VT for the DM being used.' \
			-e '/^ttyv[678][[:space:]]/ s/^/# /' "${x}" \
			|| die "Failed to sed ${x}"
		rm "${x}".bak
	done

	# This one is here because it also
	# patches "${WORKDIR}/include"
	cd "${WORKDIR}"
	epatch "${FILESDIR}/${PN}-includes.patch"
	epatch "${FILESDIR}/${PN}-11.1-elf-nhdr.patch"

	# Don't install the hesiod man page or header
	rm "${WORKDIR}"/include/hesiod.h || die
	sed -i.bak -e 's:hesiod.h::' "${WORKDIR}"/include/Makefile || die
	sed -i.bak -e 's:hesiod.c::' -e 's:hesiod.3::' \
	"${WORKDIR}"/lib/libc/net/Makefile.inc || die

	# Fix the Makefiles of these few libraries that will overwrite our LDADD.
	cd "${S}"
	for dir in libradius libtacplus libcam libdevstat libfetch libgeom libmemstat libopie \
		libsmb libprocstat libulog; do sed -i.bak -e 's:LDADD=:LDADD+=:g' "${dir}/Makefile" || \
		die "Problem fixing \"${dir}/Makefile"
	done
	# Call LD with LDFLAGS, rename them to RAW_LDFLAGS
	sed -e 's/LDFLAGS/RAW_LDFLAGS/g' \
		-i "${S}/csu/i386/Makefile" || die

	if install --version 2> /dev/null | grep -q GNU; then
		sed -i.bak -e 's:${INSTALL} -C:${INSTALL}:' "${WORKDIR}/include/Makefile"
	fi

	# libsysdecode requires the latest headers.
	need_bootstrap && \
		sed -i "s:\${DESTDIR}\${INCLUDEDIR}:${WORKDIR}/include_proper_${ABI}:g" "${S}/libsysdecode/Makefile"

	# Taken from freebsd-libexec.
	cd "${WORKDIR}/libexec"
	dummy_mk smrsh mail.local tcpd telnetd rshd rlogind ftpd
	# The old version of yacc doesn't support YFLAGS="-i".
	if has_version "<sys-freebsd/freebsd-ubin-11.0"; then
		sed -i -e '/^YFLAGS/d' "${WORKDIR}/libexec/dma/dmagent/Makefile"
	fi

	# Try to fix sed calls for GNU sed. Do it only with GNU userland and force
	# BSD's sed on BSD.
	cd "${S}"
	if [[ ${CBUILD:-${CHOST}} != *bsd* ]]; then
		find . -name Makefile -exec sed -ibak 's/sed -i /sed -i/' {} \;
		sed -i -e 's/-i ""/-i""/' "${S}/csu/Makefile.inc" || die
	fi

	if use build; then
		cd "${WORKDIR}"
		# This patch has to be applied on ${WORKDIR}/sys, so we do it here since it
		# shouldn't be a symlink to /usr/src/sys (which should be already patched)
		epatch "${FILESDIR}"/freebsd-sources-9.0-sysctluint.patch
		return 0
	fi

	if ! is_crosscompile ; then
		if [[ ! -e "${WORKDIR}/sys" ]]; then
			ln -s "${SYSROOT}/usr/src/sys" "${WORKDIR}/sys" || die "Couldn't make sys symlink!"
		fi
	else
		sed -i.bak -e "s:/usr/include:/usr/${CTARGET}/usr/include:g" \
			"${S}/libc/rpc/Makefile.inc" \
			"${S}/libc/yp/Makefile.inc"
	fi
}

bootstrap_lib() {
	for i ; do
		cd "${WORKDIR}/${i}" || die "missing ${i}"
		freebsd_src_compile
		append-ldflags "-L${MAKEOBJDIRPREFIX}/${WORKDIR}/${i}"
	done
}

get_csudir() {
	if [ -d "${WORKDIR}/lib/csu/$1-elf" ]; then
		echo "lib/csu/$1-elf"
	else
		echo "lib/csu/$1"
	fi
}

bootstrap_csu() {
	local csudir="$(get_csudir $(tc-arch-kernel ${CTARGET}))"
	export RAW_LDFLAGS=$(raw-ldflags)
	bootstrap_lib "${csudir}"

	CFLAGS="${CFLAGS} -B ${MAKEOBJDIRPREFIX}/${WORKDIR}/${csudir}"
	append-ldflags "-B ${MAKEOBJDIRPREFIX}/${WORKDIR}/${csudir}"

	bootstrap_lib "gnu/lib/csu"

	cd "${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/csu"
	for i in *.So ; do
		ln -s $i ${i%.So}S.o
	done
	CFLAGS="${CFLAGS} -B ${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/csu"
	append-ldflags "-B ${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/csu"
}

# Compile libssp_nonshared.a and add it's path to LDFLAGS.
bootstrap_libssp_nonshared() {
	bootstrap_lib "gnu/lib/libssp/libssp_nonshared"
}

# We should call this function to compile itself correctly.
# A better solution is very welcome.
bootstrap_libc() {
	mkdir "${WORKDIR}/bootstrap_libc_${ABI}" || die
	append-ldflags "-L${WORKDIR}/bootstrap_libc_${ABI}"

	bootstrap_lib "lib/libc" "lib/libc_nonshared"
	echo "GROUP ( ${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libc/libc.so.7 ${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libc_nonshared/libc_nonshared.a ${MAKEOBJDIRPREFIX}/${WORKDIR}/gnu/lib/libssp/libssp_nonshared/libssp_nonshared.a )" > "${WORKDIR}/bootstrap_libc_${ABI}/libc.so" || die
}

bootstrap_libgcc() {
	bootstrap_lib "lib/libcompiler_rt"
	cd "${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libcompiler_rt" || die
	ln -s libcompiler_rt.a libgcc.a || die

	bootstrap_libc
	bootstrap_lib "gnu/lib/libgcc"
}

bootstrap_libthr() {
	bootstrap_lib "lib/libthr"
	cd "${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libthr" || die
	ln -s libthr.so libpthread.so
}

# What to build for a cross-compiler.
# We also need the csu but this has to be handled separately.
CROSS_SUBDIRS="lib/libc lib/msun gnu/lib/libssp/libssp_nonshared lib/libthr lib/libutil lib/librt lib/libc_nonshared lib/libcompiler_rt"

# What to build for non-default ABIs.
NON_NATIVE_SUBDIRS="${CROSS_SUBDIRS} gnu/lib/csu gnu/lib/libgcc lib/libmd lib/libcrypt lib/libsbuf lib/libcam lib/libelf lib/libiconv_modules"

# Subdirs for a native build:
NATIVE_SUBDIRS="lib gnu/lib/libssp/libssp_nonshared gnu/lib/libregex gnu/lib/csu gnu/lib/libgcc lib/libiconv_modules"

# Is my $ABI native ?
is_native_abi() {
	is_crosscompile && return 1
	multilib_is_native_abi
}

# Do we need to bootstrap the csu and libssp_nonshared?
need_bootstrap() {
	is_crosscompile || use build || { ! is_native_abi && ! has_version '>=sys-freebsd/freebsd-lib-9.1-r8[multilib]' && ! has_version ">=sys-freebsd/freebsd-lib-9.1-r11[${MULTILIB_USEDEP}]" ; } || has_version "<${CATEGORY}/${P}"
}

# Get the subdirs we are building.
get_subdirs() {
	local ret=""
	if is_native_abi ; then
		# If we are building for the native ABI, build everything
		ret="${NATIVE_SUBDIRS}"
	elif is_crosscompile ; then
		# With a cross-compiler we only build the very core parts.
		ret="${CROSS_SUBDIRS}"
		if [ "${EBUILD_PHASE}" = "install" ]; then
			# Add the csu dir first when installing. We treat it separately for
			# compiling.
			ret="$(get_csudir $(tc-arch-kernel ${CTARGET})) ${ret}"
		fi
	else
		# For the non-native ABIs we only build the csu parts and very core
		# libraries for now.
		ret="${NON_NATIVE_SUBDIRS} $(get_csudir $(tc-arch-kernel ${CHOST}))"
	fi
	echo "${ret}"
}

# Bootstrap the core libraries and setup the flags so that the other parts can
# build against it.
do_bootstrap() {
	einfo "Bootstrapping on ${CHOST} for ${CTARGET}"
	if ! is_crosscompile ; then
		# Pre-install headers, but not when building a cross-compiler since we
		# assume they have been installed in the previous pass.
		einfo "Pre-installing includes in include_proper_${ABI}"
		mkdir "${WORKDIR}/include_proper_${ABI}" || die
		CTARGET="${CHOST}" install_includes "/include_proper_${ABI}"
		CFLAGS="${CFLAGS} -isystem ${WORKDIR}/include_proper_${ABI}"
		[[ $(tc-getCXX) = *clang++* ]] && CXXFLAGS="${CXXFLAGS} -isystem /usr/include/c++/v1"
		CXXFLAGS="${CXXFLAGS} -isystem ${WORKDIR}/include_proper_${ABI}"
		mymakeopts="${mymakeopts} RPCDIR=${WORKDIR}/include_proper_${ABI}/rpcsvc"
	fi
	bootstrap_csu
	bootstrap_libssp_nonshared
	if is_crosscompile ; then
		bootstrap_lib "lib/libcompiler_rt"
		bootstrap_libc
	else
		is_native_abi || bootstrap_libgcc
		is_native_abi && has_version "<=sys-freebsd/freebsd-lib-10.0" && bootstrap_libgcc
	fi
	is_native_abi   || bootstrap_libthr
}

# Taken from freebsd-libexec.
libexec_setup_multilib_vars() {
	export mymakeopts="${mymakeopts} WITHOUT_RCMDS= WITHOUT_PF= "
	need_bootstrap && CFLAGS="${CFLAGS} -isystem ${WORKDIR}/include_proper_${ABI}"
	append-ldflags "-L${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libc"
	if ! multilib_is_native_abi ; then
		cd "${WORKDIR}/libexec/rtld-elf" || die
		export mymakeopts="${mymakeopts} PROG=ld-elf32.so.1 "
	else
		cd "${WORKDIR}/libexec" || die
	fi
	"$@"
}

# Compile it. Assume we have the toolchain setup correctly.
do_compile() {
	# Bootstrap if needed, otherwise assume the system headers are in
	# /usr/include.
	if need_bootstrap ; then
		do_bootstrap
	else
		CFLAGS="${CFLAGS} -isystem /usr/include"
		[[ $(tc-getCXX) = *clang++* ]] && CXXFLAGS="${CXXFLAGS} -isystem /usr/include/c++/v1"
	fi

	export RAW_LDFLAGS=$(raw-ldflags)

	# Everything is now setup, build it!
	for i in $(get_subdirs) ; do
		einfo "Building in ${i}... with CC=${CC} and CFLAGS=${CFLAGS}"
		cd "${WORKDIR}/${i}/" || die "missing ${i}."
		freebsd_src_compile || die "make ${i} failed"
	done
}

src_compile() {
	# Does not work with GNU sed
	# Force BSD's sed on BSD.
	if [[ ${CBUILD:-${CHOST}} == *bsd* ]]; then
		export ESED=/usr/bin/sed
		unalias sed
	fi

	use usb && export NON_NATIVE_SUBDIRS="${NON_NATIVE_SUBDIRS} lib/libusb lib/libusbhid"

	cd "${WORKDIR}/include"
	$(freebsd_get_bmake) CC="$(tc-getCC)" SRCTOP="${WORKDIR}" || die "make include failed"

	use headers-only && return 0

	# Bug #270098
	append-flags $(test-flags -fno-strict-aliasing)

	# Bug #324445
	append-flags $(test-flags -fno-strict-overflow)

	# strip flags and do not do it later, we only add safe, and in fact
	# needed flags after all
	strip-flags
	export NOFLAGSTRIP=yes
	if is_crosscompile ; then
		export YACC='yacc -by'
		CHOST=${CTARGET} tc-export CC LD CXX RANLIB
		mymakeopts="${mymakeopts} NLS="
		CFLAGS="${CFLAGS} -isystem /usr/${CTARGET}/usr/include"
		CXXFLAGS="${CXXFLAGS} -isystem /usr/${CTARGET}/usr/include"
		append-ldflags "-L${WORKDIR}/${CHOST}/${WORKDIR}/lib/libc"
	fi

	if is_crosscompile ; then
		do_compile
	else
		local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abis) )
		multibuild_foreach_variant freebsd_multilib_multibuild_wrapper do_compile
		multibuild_foreach_variant freebsd_multilib_multibuild_wrapper libexec_setup_multilib_vars freebsd_src_compile
	fi
}

gen_libc_ldscript() {
	# Parameters:
	#   $1 = target libdir
	#   $2 = source libc dir
	#   $3 = source libssp_nonshared dir

	# Clear the symlink.
	rm -f "${DESTDIR}/$2/libc.so" || die

	# Move the library if needed
	if [ "$1" != "$2" ] ; then
		mv "${DESTDIR}/$2/libc.so.7" "${DESTDIR}/$1/" || die
	fi

	# Generate libc.so ldscript for inclusion of libssp_nonshared.a when linking
	# this is done to avoid having to touch gcc spec file as it is currently
	# done on FreeBSD upstream, mostly because their binutils aren't able to
	# cope with linker scripts yet.
	# Taken from toolchain-funcs.eclass:
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	# The iconv symbol is provided by libc_nonshared.a.
	# http://svnweb.freebsd.org/base?view=revision&amp;revision=258283
	cat > "${DESTDIR}/$2/libc.so" <<-END_LDSCRIPT
/* GNU ld script
   SSP (-fstack-protector) requires __stack_chk_fail_local to be local.
   GCC invokes this symbol in a non-PIC way, which results in TEXTRELs if
   this symbol was provided by a shared libc. So we link in
   libssp_nonshared.a from here.
 */
${output_format}
GROUP ( /$1/libc.so.7 /$3/libc_nonshared.a /$3/libssp_nonshared.a )
END_LDSCRIPT
}

header_list=""

move_header() {
	local dirname=$(dirname ${1})
	local filename=$(basename ${1})

	if [ ! -d "${dirname}/${ABI}" ] ; then
		mkdir "${dirname}/${ABI}" || die
	fi

	mv "${1}" "${dirname}/${ABI}/" || die

	export header_list="${header_list} ${1}"
}

make_header_template() {
	cat <<-END_HEADER
/*
 * Wrapped header for multilib support.
 * See the real headers included below.
 */

#if defined(__x86_64__)
  @ABI_amd64_fbsd@
#elif defined(__i386__)
  @ABI_x86_fbsd@
#else
  @ABI_${DEFAULT_ABI}@
#endif
END_HEADER
}

wrap_header() {
	local dirname=$(dirname ${1})
	local filename=$(basename ${1})

	if [ -n "${dirname#.}" ] ; then
		dirname="${dirname}/${2}"
	else
		dirname="${2}"
	fi

	if [ -f "${dirname}/${filename}" ] ; then
		sed -e "s:@ABI_${2}@:#include <${dirname}/${filename}>:" ${1}
	else
		cat ${1}
	fi
}

wrap_header_end() {
	sed -e "s:@ABI_.*@:#error \"Sorry, no support for your ABI.\":" ${1}
}

do_install() {
	if is_crosscompile ; then
		INCLUDEDIR="/usr/${CTARGET}/usr/include"
	else
		INCLUDEDIR="/usr/include"
	fi

	dodir ${INCLUDEDIR}
	CTARGET="${CHOST}" \
		install_includes ${INCLUDEDIR}

	is_crosscompile && use headers-only && return 0

	# Install a libusb.pc for better compat with Linux's libusb
	if use usb ; then
		dodir /usr/$(get_libdir)/pkgconfig
		sed -i.bkp "s:^libdir=.*:libdir=/usr/$(get_libdir):g" "${S}"/libusb/libusb-*.pc
	fi

	for i in $(get_subdirs) ; do
		if [[ ${i} != *libiconv_modules* ]] ; then
			einfo "Installing in ${i}..."
			cd "${WORKDIR}/${i}/" || die "missing ${i}."
			freebsd_src_install || die "Install ${i} failed"
		fi
	done

	if ! is_crosscompile; then
		local mymakeopts_save="${mymakeopts}"
		mymakeopts="${mymakeopts} SHLIBDIR=/usr/$(get_libdir)/i18n LIBDIR=/usr/$(get_libdir)/i18n"

		einfo "Installing in lib/libiconv_modules..."
		cd "${WORKDIR}/lib/libiconv_modules/" || die "missing libiconv_modules."
		freebsd_src_install || die "Install lib/libiconv_modules failed"

		mymakeopts="${mymakeopts_save}"
	fi

	if ! is_crosscompile ; then
		if ! multilib_is_native_abi ; then
			DESTDIR="${D}" gen_libc_ldscript "usr/$(get_libdir)" "usr/$(get_libdir)" "usr/$(get_libdir)"
		else
			dodir "$(get_libdir)"
			DESTDIR="${D}" gen_libc_ldscript "$(get_libdir)" "usr/$(get_libdir)" "usr/$(get_libdir)"
		fi
	else
		CHOST=${CTARGET} DESTDIR="${D}/usr/${CTARGET}/" gen_libc_ldscript "usr/lib" "usr/lib" "usr/lib"
		# We're done for the cross libc here.
		return 0
	fi

	# Generate ldscripts for core libraries that will go in /
	multilib_is_native_abi && \
		gen_usr_ldscript -a alias cam geom ipsec jail kiconv \
			kvm m md procstat sbuf thr ufs util elf

	if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]] ; then
		cd "${D}/usr/include"
		for i in machine/*.h fenv.h ; do
			move_header ${i}
		done
		if multilib_is_native_abi ; then
			# Supposedly the last one!
			local uniq_headers="$(echo ${header_list} | tr ' ' '\n' | sort | uniq | tr '\n' ' ')"
			for j in ${uniq_headers} ; do
				make_header_template > ${j}
				for i in $(get_all_abis) ; do
					wrap_header ${j} ${i} > ${j}.new
					cp ${j}.new ${j}
					rm -f ${j}.new
				done
				wrap_header_end ${j} > ${j}.new
				cp ${j}.new ${j}
				rm -f ${j}.new
			done
		fi
	fi
}

src_install() {
	if is_crosscompile ; then
		einfo "Installing for ${CTARGET} in ${CHOST}.."
		# From this point we need to force: get stripped with the correct tools,
		# get tc-arch-kernel to return the right value, etc.
		export CHOST=${CTARGET}

		mymakeopts="${mymakeopts} WITHOUT_MAN= \
			INCLUDEDIR=/usr/${CTARGET}/usr/include \
			SHLIBDIR=/usr/${CTARGET}/usr/lib \
			LIBDIR=/usr/${CTARGET}/usr/lib"

		dosym "usr/include" "/usr/${CTARGET}/sys-include"
		do_install

		return 0
	else
		export STRIP_MASK="*/usr/lib*/*crt*.o"
		local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abis) )
		multibuild_foreach_variant freebsd_multilib_multibuild_wrapper do_install

		# Taken from freebsd-libexec.
		multibuild_foreach_variant freebsd_multilib_multibuild_wrapper libexec_setup_multilib_vars freebsd_src_install
		insinto /etc
		doins "${WORKDIR}/etc/gettytab"
		newinitd "${FILESDIR}/bootpd.initd" bootpd
		newconfd "${FILESDIR}/bootpd.confd" bootpd

		if use xinetd; then
			for rpcd in rstatd rusersd walld rquotad sprayd; do
				insinto /etc/xinetd.d
				newins "${FILESDIR}/${rpcd}.xinetd" ${rpcd}
			done
		fi
	fi

	cd "${WORKDIR}/etc/"
	insinto /etc
	doins nls.alias mac.conf netconfig

	# Install ttys file
	local MACHINE="$(tc-arch-kernel)"
	doins "etc.${MACHINE}"/*
}

install_includes()
{
	local INCLUDEDIR="$1"

	# The idea is to be called from either install or unpack.
	# During unpack it's required to install them as portage's user.
	if [[ "${EBUILD_PHASE}" == "install" ]]; then
		local DESTDIR="${D}"
		BINOWN="root"
		BINGRP="wheel"
	else
		local DESTDIR="${WORKDIR}"
		[[ -z "${USER}" ]] && USER="portage"
		BINOWN="${USER}"
		[[ -z "${GROUPS}" ]] && GROUPS="portage"
		BINGRP="${GROUPS}"
	fi

	# Must exist before we use it.
	[[ -d "${DESTDIR}${INCLUDEDIR}" ]] || die "dodir or mkdir ${INCLUDEDIR} before using install_includes."
	cd "${WORKDIR}/include"

	local MACHINE="$(tc-arch-kernel)"

	einfo "Installing includes into ${INCLUDEDIR} as ${BINOWN}:${BINGRP}..."
	$(freebsd_get_bmake) installincludes \
		MACHINE=${MACHINE} MACHINE_ARCH=${MACHINE} \
		DESTDIR="${DESTDIR}" \
		INCLUDEDIR="${INCLUDEDIR}" BINOWN="${BINOWN}" \
		BINGRP="${BINGRP}" \
		WITHOUT_GSSAPI= \
		$(usex zfs "WITH_CDDL=" "WITHOUT_CDDL=") \
		SRCTOP="${WORKDIR}"|| die "install_includes() failed"
	einfo "includes installed ok."
	EXTRA_INCLUDES="lib/librtld_db lib/libutil lib/msun gnu/lib/libregex lib/libcasper lib/libmp"
	for i in $EXTRA_INCLUDES; do
		einfo "Installing $i includes into ${INCLUDEDIR} as ${BINOWN}:${BINGRP}..."
		cd "${WORKDIR}/$i" || die
		$(freebsd_get_bmake) installincludes DESTDIR="${DESTDIR}" \
			MACHINE=${MACHINE} MACHINE_ARCH=${MACHINE} \
			INCLUDEDIR="${INCLUDEDIR}" BINOWN="${BINOWN}" \
			BINGRP="${BINGRP}" \
			SRCTOP="${WORKDIR}" || die "problem installing $i includes."
		einfo "$i includes installed ok."
	done
}

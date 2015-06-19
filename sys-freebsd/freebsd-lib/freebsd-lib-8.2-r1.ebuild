# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-lib/freebsd-lib-8.2-r1.ebuild,v 1.11 2014/03/24 17:49:33 ssuominen Exp $

EAPI=2

inherit bsdmk freebsd flag-o-matic multilib toolchain-funcs eutils

DESCRIPTION="FreeBSD's base system libraries"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"

# Crypto is needed to have an internal OpenSSL header
# sys is needed for libalias, probably we can just extract that instead of
# extracting the whole tarball
SRC_URI="mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${CRYPTO}.tar.bz2
		mirror://gentoo/${LIBEXEC}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2
		mirror://gentoo/${INCLUDE}.tar.bz2
		mirror://gentoo/${USBIN}.tar.bz2
		mirror://gentoo/${GNU}.tar.bz2
		build? (
			mirror://gentoo/${SYS}.tar.bz2 )"

if [ "${CATEGORY#*cross-}" = "${CATEGORY}" ]; then
	RDEPEND="ssl? ( dev-libs/openssl )
		hesiod? ( net-dns/hesiod )
		kerberos? ( virtual/krb5 )
		usb? ( !dev-libs/libusb )
		userland_GNU? ( sys-apps/mtree )
		>=dev-libs/expat-2.0.1
		!sys-freebsd/freebsd-headers"
	DEPEND="${RDEPEND}
		>=sys-devel/flex-2.5.31-r2
		=sys-freebsd/freebsd-sources-${RV}*
		!bootstrap? ( app-arch/bzip2 )"
else
	SRC_URI="${SRC_URI}
			mirror://gentoo/${SYS}.tar.bz2"
fi

DEPEND="${DEPEND}
		=sys-freebsd/freebsd-mk-defs-${RV}*"

S="${WORKDIR}/lib"

export CTARGET=${CTARGET:-${CHOST}}
if [ "${CTARGET}" = "${CHOST}" -a "${CATEGORY#*cross-}" != "${CATEGORY}" ]; then
	export CTARGET=${CATEGORY/cross-}
fi

IUSE="atm bluetooth ssl hesiod ipv6 kerberos usb netware
	build bootstrap crosscompile_opts_headers-only"

pkg_setup() {
	[ -c /dev/zero ] || \
		die "You forgot to mount /dev; the compiled libc would break."

	if ! use ssl && use kerberos; then
		eerror "If you want kerberos support you need to enable ssl support, too."
	fi

	use atm || mymakeopts="${mymakeopts} WITHOUT_ATM= "
	use bluetooth || mymakeopts="${mymakeopts} WITHOUT_BLUETOOTH= "
	use hesiod || mymakeopts="${mymakeopts} WITHOUT_HESIOD= "
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6_SUPPORT= "
	use kerberos || mymakeopts="${mymakeopts} WITHOUT_KERBEROS_SUPPORT= "
	use netware || mymakeopts="${mymakeopts} WITHOUT_IPX= WITHOUT_IPX_SUPPORT= WITHOUT_NCP= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL= "
	use usb || mymakeopts="${mymakeopts} WITHOUT_USB= "

	mymakeopts="${mymakeopts} WITHOUT_BIND= WITHOUT_BIND_LIBS= WITHOUT_SENDMAIL="

	if [ "${CTARGET}" != "${CHOST}" ]; then
		mymakeopts="${mymakeopts} MACHINE=$(tc-arch-kernel ${CTARGET})"
		mymakeopts="${mymakeopts} MACHINE_ARCH=$(tc-arch-kernel ${CTARGET})"
	fi
}

PATCHES=(
	"${FILESDIR}/${PN}-6.0-pmc.patch"
	"${FILESDIR}/${PN}-6.0-gccfloat.patch"
	"${FILESDIR}/${PN}-6.0-flex-2.5.31.patch"
	"${FILESDIR}/${PN}-6.1-csu.patch"
	"${FILESDIR}/${PN}-6.2-bluetooth.patch"
	"${FILESDIR}/${PN}-8.0-log2.patch"
	"${FILESDIR}/${PN}-8.0-rpcsec_gss.patch"
	"${FILESDIR}/${PN}-8.2-liblink.patch"
	"${FILESDIR}/${PN}-bsdxml2expat.patch" )

# Here we disable and remove source which we don't need or want
# In order:
# - ncurses stuff
# - libexpat creates a bsdxml library which is the same as expat
# - archiving libraries (have their own ebuild)
# - sendmail libraries (they are installed by sendmail)
# - SNMP library and dependency (have their own ebuilds)
#
# The rest are libraries we already have somewhere else because
# they are contribution.
# Note: libtelnet is an internal lib used by telnet and telnetd programs
# as it's not used in freebsd-lib package itself, it's pointless building
# it here.
REMOVE_SUBDIRS="ncurses \
	libexpat \
	libz libbz2 libarchive liblzma \
	libsm libsmdb libsmutil \
	libbegemot libbsnmp \
	libpam libpcap bind libwrap libmagic \
	libcom_err libtelnet
	libedit libelf"

src_prepare() {
	sed -i.bak -e 's:-o/dev/stdout:-t:' "${S}/libc/net/Makefile.inc"
	sed -i.bak -e 's:histedit.h::' "${WORKDIR}/include/Makefile"

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
	epatch "${FILESDIR}/${PN}-8.0-gcc45.patch"
	epatch "${FILESDIR}/${PN}-8.2-nlm_syscall.patch"

	# Don't install the hesiod man page or header
	rm "${WORKDIR}"/include/hesiod.h || die
	sed -i.bak -e 's:hesiod.h::' "${WORKDIR}"/include/Makefile || die
	sed -i.bak -e 's:hesiod.c::' -e 's:hesiod.3::' \
	"${WORKDIR}"/lib/libc/net/Makefile.inc || die

	# Fix the Makefiles of these few libraries that will overwrite our LDADD.
	cd "${S}"
	for dir in libradius libtacplus libcam libdevstat libfetch libgeom libmemstat libopie \
		libsmb; do sed -i.bak -e 's:LDADD=:LDADD+=:g' "${dir}/Makefile" || \
		die "Problem fixing \"${dir}/Makefile"
	done
	if use build; then
		cd "${WORKDIR}"
		# This patch has to be applied on ${WORKDIR}/sys, so we do it here since it
		# shouldn't be a symlink to /usr/src/sys (which should be already patched)
		epatch "${FILESDIR}"/${PN}-7.1-types.h-fix.patch
		# Preinstall includes so we don't use the system's ones.
		mkdir "${WORKDIR}/include_proper" || die "Couldn't create ${WORKDIR}/include_proper"
		install_includes "/include_proper"
		return 0
	fi

	if [ "${CTARGET}" = "${CHOST}" ]; then
		ln -s "/usr/src/sys-${RV}" "${WORKDIR}/sys" || die "Couldn't make sys symlink!"
	else
		sed -i.bak -e "s:/usr/include:/usr/${CTARGET}/usr/include:g" \
			"${S}/libc/rpc/Makefile.inc" \
			"${S}/libc/yp/Makefile.inc"
	fi

	if install --version 2> /dev/null | grep -q GNU; then
		sed -i.bak -e 's:${INSTALL} -C:${INSTALL}:' "${WORKDIR}/include/Makefile"
	fi

	# Preinstall includes so we don't use the system's ones.
	mkdir "${WORKDIR}/include_proper" || die "Couldn't create ${WORKDIR}/include_proper"
	install_includes "/include_proper"

	# Let arch-specific includes to be found
	local machine
	machine=$(tc-arch-kernel ${CTARGET})
	ln -s "${WORKDIR}/sys/${machine}/include" "${WORKDIR}/include/machine" || \
		die "Couldn't make ${machine}/include symlink."

	cd "${S}"
	use bootstrap && dummy_mk libstand
	# Call LD with LDFLAGS, rename them to RAW_LDFLAGS
	sed -e 's/LDFLAGS/RAW_LDFLAGS/g' \
		-i "${S}/csu/i386-elf/Makefile" \
		-i "${S}/csu/ia64/Makefile" || die
}

src_compile() {
	cd "${WORKDIR}/include"
	$(freebsd_get_bmake) CC="$(tc-getCC)" || die "make include failed"

	use crosscompile_opts_headers-only && return 0

	# Bug #270098
	append-flags $(test-flags -fno-strict-aliasing)

	# Bug #324445
	append-flags $(test-flags -fno-strict-overflow)

	strip-flags
	if [ "${CTARGET}" != "${CHOST}" ]; then
		export YACC='yacc -by'
		CHOST=${CTARGET} tc-export CC LD CXX RANLIB
		mymakeopts="${mymakeopts} NO_MANCOMPRESS= NO_INFOCOMPRESS= NLS="

		local machine
		machine=$(tc-arch-kernel ${CTARGET})

		local csudir
		if [ -d "${S}/csu/${machine}-elf" ]; then
			csudir="${S}/csu/${machine}-elf"
		else
			csudir="${S}/csu/${machine}"
		fi
		export RAW_LDFLAGS=$(raw-ldflags)
		cd "${csudir}"
		$(freebsd_get_bmake) ${mymakeopts} || die "make csu failed"

		append-flags "-isystem /usr/${CTARGET}/usr/include"
		append-flags "-isystem ${WORKDIR}/lib/libutil"
		append-flags "-isystem ${WORKDIR}/lib/msun/${machine/i386/i387}"
		append-flags "-B ${csudir}"
		append-ldflags "-B ${csudir}"

		# First compile libssp_nonshared.a and add it's path to LDFLAGS.
		cd "${WORKDIR}/gnu/lib/libssp/libssp_nonshared/" || die "missing libssp."
		$(freebsd_get_bmake) ${mymakeopts} || die "make libssp failed"
		append-ldflags "-L${WORKDIR}/gnu/lib/libssp/libssp_nonshared/"

		export RAW_LDFLAGS=$(raw-ldflags)
		cd "${S}/libc"
		$(freebsd_get_bmake) ${mymakeopts} || die "make libc failed"
		cd "${S}/msun"
		append-ldflags "-L${WORKDIR}/lib/libc"
		export RAW_LDFLAGS=$(raw-ldflags)
		LDADD="-lssp_nonshared" $(freebsd_get_bmake) ${mymakeopts} || die "make libc failed"
		cd "${WORKDIR}/gnu/lib/libssp/" || die "missing libssp."
		$(freebsd_get_bmake) ${mymakeopts} || die "make libssp failed"
		cd "${WORKDIR}/lib/libthr/" || die "missing libthr"
		$(freebsd_get_bmake) ${mymakeopts} || die "make libthr failed"
	else
		# Forces to use the local copy of headers as they might be outdated in
		# the system
		append-flags "-isystem '${WORKDIR}/include_proper'"

		# First compile libssp_nonshared.a and add it's path to LDFLAGS.
		einfo "Compiling libssp in \"${WORKDIR}/gnu/lib/libssp/\"."
		cd "${WORKDIR}/gnu/lib/libssp/" || die "missing libssp."
		NOFLAGSTRIP=yes freebsd_src_compile
		# Hack libssp_nonshared.a into libc & others since we don't have
		# the linker script in place yet.
		append-ldflags "-L${WORKDIR}/gnu/lib/libssp/libssp_nonshared/"
		einfo "Compiling libc."
		cd "${S}"
		export RAW_LDFLAGS=$(raw-ldflags)
		NOFLAGSTRIP=yes LDADD="-lssp_nonshared" freebsd_src_compile
	fi
}

src_install() {
	[ "${CTARGET}" = "${CHOST}" ] \
		&& INCLUDEDIR="/usr/include" \
		|| INCLUDEDIR="/usr/${CTARGET}/usr/include"
	dodir ${INCLUDEDIR}
	einfo "Installing for ${CTARGET} in ${CHOST}.."
	install_includes ${INCLUDEDIR}

	# Install math.h when crosscompiling, at this point
	if [ "${CHOST}" != "${CTARGET}" ]; then
		insinto "/usr/${CTARGET}/usr/include"
		doins "${S}/msun/src/math.h"
	fi

	use crosscompile_opts_headers-only && return 0
	local mylibdir=$(get_libdir)

	if [ "${CTARGET}" != "${CHOST}" ]; then
		local csudir
		if [ -d "${S}/csu/$(tc-arch-kernel ${CTARGET})-elf" ]; then
			csudir="${S}/csu/$(tc-arch-kernel ${CTARGET})-elf"
		else
			csudir="${S}/csu/$(tc-arch-kernel ${CTARGET})"
		fi
		cd "${csudir}"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install \
			FILESDIR="/usr/${CTARGET}/usr/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install csu failed"

		cd "${S}/libc"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install NO_MAN= \
			SHLIBDIR="/usr/${CTARGET}/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install libc failed"

		cd "${S}/msun"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install NO_MAN= \
			INCLUDEDIR="/usr/${CTARGET}/usr/include" \
			SHLIBDIR="/usr/${CTARGET}/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install msun failed"

		cd "${WORKDIR}/gnu/lib/libssp/"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install NO_MAN= \
			INCLUDEDIR="/usr/${CTARGET}/usr/include" \
			SHLIBDIR="/usr/${CTARGET}/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install ssp failed"

		cd "${WORKDIR}/lib/libthr/"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install NO_MAN= \
			INCLUDEDIR="/usr/${CTARGET}/usr/include" \
			SHLIBDIR="/usr/${CTARGET}/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install libthr failed"

		dosym "usr/include" "/usr/${CTARGET}/sys-include"
	else
		# Set SHLIBDIR and LIBDIR for multilib
		cd "${WORKDIR}/gnu/lib/libssp"
		SHLIBDIR="/${mylibdir}" LIBDIR="/usr/${mylibdir}" mkinstall || die "Install ssp failed."
		cd "${S}"
		SHLIBDIR="/${mylibdir}" LIBDIR="/usr/${mylibdir}" mkinstall || die "Install failed"
	fi

	# Don't install the rest of the configuration files if crosscompiling
	if [ "${CTARGET}" != "${CHOST}" ] ; then
		# This is to get it stripped with the correct tools, otherwise it gets
		# stripped with the host strip.
		export CHOST=${CTARGET}
		return 0
	fi

	# Symlink libbsdxml to libexpat as we use expat in favor of the renaming done
	# on FreeBSD.
	dosym libexpat.so /usr/${mylibdir}/libbsdxml.so

	# install libstand files
	dodir /usr/include/libstand
	insinto /usr/include/libstand
	doins "${S}"/libstand/*.h

	cd "${WORKDIR}/etc/"
	insinto /etc
	doins auth.conf nls.alias mac.conf netconfig

	# Install ttys file
	local MACHINE="$(tc-arch-kernel)"
	doins "etc.${MACHINE}"/*

	# Generate ldscripts, otherwise bad thigs are supposed to happen
	gen_usr_ldscript libalias_cuseeme.so libalias_dummy.so libalias_ftp.so \
		libalias_irc.so libalias_nbt.so libalias_pptp.so libalias_skinny.so \
		libalias_smedia.so libssp.so
	# These show on QA warnings too, however they're pretty much bsd only,
	# aka, no autotools for them.
	#	libbsdxml.so libcam.so libcrypt.so libdevstat.so libgeom.so \
	#	libipsec.so libipx.so libkiconv.so libkvm.so libmd.so libsbuf.so libufs.so \
	#	libutil.so

	# Generate libc.so ldscript for inclusion of libssp_nonshared.a when linking
	# this is done to avoid having to touch gcc spec file as it is currently
	# done on FreeBSD upstream, mostly because their binutils aren't able to
	# cope with linker scripts yet.
	# Taken from toolchain-funcs.eclass:
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"
	# Clear the symlink.
	rm -f "${D}/usr/${mylibdir}/libc.so"
	cat > "${D}/usr/${mylibdir}/libc.so" <<-END_LDSCRIPT
/* GNU ld script
   SSP (-fstack-protector) requires __stack_chk_fail_local to be local.
   GCC invokes this symbol in a non-PIC way, which results in TEXTRELs if
   this symbol was provided by a shared libc. So we link in
   libssp_nonshared.a from here.
 */
${output_format}
GROUP ( /${mylibdir}/libc.so.7 /usr/${mylibdir}/libssp_nonshared.a )
END_LDSCRIPT

	dodir /etc/sandbox.d
	cat - > "${D}"/etc/sandbox.d/00freebsd <<EOF
# /dev/crypto is used mostly by OpenSSL on *BSD platforms
# leave it available as packages might use OpenSSL commands
# during compile or install phase.
SANDBOX_PREDICT="/dev/crypto"
EOF

	# Install a libusb.pc for better compat with Linux's libusb
	if use usb ; then
		dodir /usr/$(get_libdir)/pkgconfig
		sed -e "s:@LIBDIR@:/usr/$(get_libdir):" "${FILESDIR}/libusb.pc.in" > "${D}/usr/$(get_libdir)/pkgconfig/libusb.pc" || die
	fi
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

	# This is for ssp/ssp.h.
	einfo "Building ssp.h"
	cd "${WORKDIR}/gnu/lib/libssp/" || die "missing libssp"
	$(freebsd_get_bmake) ssp.h || die "problem building ssp.h"

	# Must exist before we use it.
	[[ -d "${DESTDIR}${INCLUDEDIR}" ]] || die "dodir or mkdir ${INCLUDEDIR} before using install_includes."
	cd "${WORKDIR}/include"

	local MACHINE="$(tc-arch-kernel)"

	einfo "Installing includes into ${INCLUDEDIR} as ${BINOWN}:${BINGRP}..."
	$(freebsd_get_bmake) installincludes \
		MACHINE=${MACHINE} DESTDIR="${DESTDIR}" \
		INCLUDEDIR="${INCLUDEDIR}" BINOWN="${BINOWN}" \
		BINGRP="${BINGRP}" || die "install_includes() failed"
	einfo "includes installed ok."
	einfo "Installing ssp includes into ${INCLUDEDIR} as ${BINOWN}:${BINGRP}..."
	cd "${WORKDIR}/gnu/lib/libssp"
	$(freebsd_get_bmake) installincludes DESTDIR="${DESTDIR}" \
		MACHINE=${MACHINE} INCLUDEDIR="${INCLUDEDIR}" BINOWN="${BINOWN}" \
		BINGRP="${BINGRP}" || die "problem installing ssp includes."
	einfo "ssp includes installed ok."
	einfo "Installing librtld_db includes into ${INCLUDEDIR} as ${BINOWN}:${BINGRP}..."
	cd "${S}/librtld_db" || die "missing librtld_db"
	$(freebsd_get_bmake) installincludes DESTDIR="${DESTDIR}" \
		MACHINE=${MACHINE} INCLUDEDIR="${INCLUDEDIR}" BINOWN="${BINOWN}" \
		BINGRP="${BINGRP}" || die "problem installing librtld_db includes."
	einfo "librtld_db includes installed ok."
}

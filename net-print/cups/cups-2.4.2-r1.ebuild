# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info xdg multilib-minimal optfeature pam toolchain-funcs

MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_rc/rc}"
MY_PV="${MY_PV/_p/op}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenPrinting/cups.git"
	[[ ${PV} != 9999 ]] && EGIT_BRANCH=branch-${PV/.9999}
else
	SRC_URI="https://github.com/OpenPrinting/cups/releases/download/v${MY_PV}/cups-${MY_PV}-source.tar.gz"
	if [[ ${PV} != *_beta* ]] && [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
	fi
fi

DESCRIPTION="The Common Unix Printing System"
HOMEPAGE="https://www.cups.org/ https://github.com/OpenPrinting/cups"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="acl dbus debug kerberos openssl pam selinux +ssl static-libs systemd test usb X xinetd zeroconf"

# As of 2.4.2, they don't actually seem to be interactive (they pass some flags
# by default to input for us), but they fail on some greyscale issue w/ poppler?
RESTRICT="!test? ( test ) test"

BDEPEND="
	acct-group/lp
	acct-group/lpadmin
	virtual/pkgconfig
"
DEPEND="
	app-text/libpaper
	sys-libs/zlib
	acl? (
		kernel_linux? (
			sys-apps/acl
			sys-apps/attr
		)
	)
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	pam? ( sys-libs/pam )
	!pam? ( virtual/libcrypt:= )
	ssl? (
		!openssl? ( >=net-libs/gnutls-2.12.23-r6:0=[${MULTILIB_USEDEP}] )
		openssl? ( dev-libs/openssl:=[${MULTILIB_USEDEP}] )
	)
	systemd? ( sys-apps/systemd )
	usb? ( virtual/libusb:1 )
	X? ( x11-misc/xdg-utils )
	xinetd? ( sys-apps/xinetd )
	zeroconf? ( >=net-dns/avahi-0.6.31-r2[dbus,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	acct-group/lp
	acct-group/lpadmin
	selinux? ( sec-policy/selinux-cups )
"
PDEPEND=">=net-print/cups-filters-1.0.43"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.1-nostrip.patch"
	"${FILESDIR}/${PN}-2.4.1-user-AR.patch"
	"${FILESDIR}/${PN}-2.4.2-no-fortify-override.patch"
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/cups-config
)

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use kernel_linux; then
		linux-info_pkg_setup
		if  ! linux_config_exists; then
			ewarn "Can't check the linux kernel configuration."
			ewarn "You might have some incompatible options enabled."
		else
			# Recheck that we don't have usblp to collide with libusb; this should now work in most cases (bug #501122)
			if use usb; then
				if linux_chkconfig_present USB_PRINTER; then
					elog "Your USB printers will be managed via libusb. In case you run into problems, "
					elog "please try disabling USB_PRINTER support in your kernel or blacklisting the"
					elog "usblp kernel module."
					elog "Alternatively, just disable the usb useflag for cups (your printer will still work)."
				fi
			else
				if ! linux_chkconfig_present USB_PRINTER; then
					ewarn "If you plan to use USB printers you should enable the USB_PRINTER"
					ewarn "support in your kernel."
					ewarn "Please enable it:"
					ewarn "    CONFIG_USB_PRINTER=y"
					ewarn "in /usr/src/linux/.config or"
					ewarn "    Device Drivers --->"
					ewarn "        USB support  --->"
					ewarn "            [*] USB Printer support"
					ewarn "Alternatively, enable the usb useflag for cups and use the libusb code."
				fi
			fi
		fi
	fi
}

src_prepare() {
	default

	# Remove ".SILENT" rule for verbose output (bug #524338).
	sed 's#^.SILENT:##g' -i Makedefs.in || die

	AT_M4DIR="config-scripts" eautoreconf

	# Custom Makefiles
	multilib_copy_sources
}

multilib_src_configure() {
	export DSOFLAGS="${LDFLAGS}"

	# Explicitly specify compiler wrt bug #524340
	#
	# Need to override KRB5CONFIG for proper flags
	# https://github.com/apple/cups/issues/4423
	local myeconfargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		KRB5CONFIG="${EPREFIX}"/usr/bin/${CHOST}-krb5-config
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--localstatedir="${EPREFIX}"/var
		# Follow Fedora permission setting
		--with-cupsd-file-perm=0755
		--with-exe-file-perm=755
		--with-log-file-perm=0640
		# Used by Debian, also prevents printers from getting
		# disabled and users not knowing how to re-enable them
		--with-error-policy=retry-job
		# Used in Debian and Fedora
		--enable-sync-on-close
		#
		--with-rundir="${EPREFIX}"/run/cups
		--with-pkgconfpath="${EPREFIX}"/usr/$(get_libdir)/pkgconfig
		--with-cups-user=lp
		--with-cups-group=lp
		--with-docdir="${EPREFIX}"/usr/share/cups/html
		--with-system-groups=lpadmin
		--with-xinetd="${EPREFIX}"/etc/xinetd.d
		$(multilib_native_use_enable acl)
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable debug debug-guards)
		$(use_enable debug debug-printfs)
		$(use_enable kerberos gssapi)
		$(multilib_native_use_enable pam)
		$(use_enable static-libs static)
		$(use_enable test unit-tests)
		# USE="ssl" => gnutls
		# USE="ssl openssl" => openssl
		$(use_with ssl tls $(usex openssl openssl gnutls))
		$(use_with systemd ondemand systemd)
		$(multilib_native_use_enable usb libusb)
		$(use_with zeroconf dnssd avahi)
		$(multilib_is_native_abi && echo --enable-libpaper || echo --disable-libpaper)
	)

	# Handle empty LINGUAS properly, bug #771162
	if [[ -n "${LINGUAS+x}" ]] ; then
		myeconfargs+=(
			--with-languages="${LINGUAS}"
		)
	fi

	if tc-is-static-only; then
		myeconfargs+=(
			--disable-shared
		)
	fi

	# Install in /usr/libexec always, instead of using /usr/lib/cups, as that
	# makes more sense when facing multilib support.
	sed -i -e 's:CUPS_SERVERBIN="$exec_prefix/lib/cups":CUPS_SERVERBIN="$exec_prefix/libexec/cups":g' configure ||die

	# Don't use the libtool build
	# https://bugs.gentoo.org/843638
	# https://github.com/OpenPrinting/cups/pull/394
	unset LIBTOOL

	econf "${myeconfargs[@]}"

	sed -i -e "s:SERVERBIN.*:SERVERBIN = \"\$\(BUILDROOT\)${EPREFIX}/usr/libexec/cups\":" Makedefs || die
	sed -i -e "s:#define CUPS_SERVERBIN.*:#define CUPS_SERVERBIN \"${EPREFIX}/usr/libexec/cups\":" config.h || die
	sed -i -e "s:cups_serverbin=.*:cups_serverbin=\"${EPREFIX}/usr/libexec/cups\":" cups-config || die

	# Additional path corrections needed for prefix, see bug #597728
	sed \
		-e "s:ICONDIR.*:ICONDIR = ${EPREFIX}/usr/share/icons:" \
		-e "s:INITDIR.*:INITDIR = ${EPREFIX}/etc:" \
		-e "s:DBUSDIR.*:DBUSDIR = ${EPREFIX}/etc/dbus-1:" \
		-e "s:MENUDIR.*:MENUDIR = ${EPREFIX}/usr/share/applications:" \
		-i Makedefs || die
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake libs
	fi
}

multilib_src_test() {
	# Avoid using /tmp
	export CUPS_TESTBASE="${T}"/cups-tests

	mkdir "${T}"/cups-tests || die

	# We only build some of CUPS for multilib, so can't run the tests.
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake BUILDROOT="${D}" install
	else
		emake BUILDROOT="${D}" install-libs install-headers
		dobin cups-config
	fi
}

multilib_src_install_all() {
	dodoc {CHANGES,CREDITS,README}.md

	# Move the default config file to docs
	dodoc "${ED}"/etc/cups/cupsd.conf.default
	rm "${ED}"/etc/cups/cupsd.conf.default || die

	# Clean out cups init scripts
	rm -r "${ED}"/etc/{init.d/cups,rc*} || die

	# Install our init script
	local neededservices=(
		$(usex zeroconf avahi-daemon '')
		$(usex dbus dbus '')
	)
	[[ -n ${neededservices[@]} ]] && neededservices="need ${neededservices[@]}"
	cp "${FILESDIR}"/cupsd.init.d-r4 "${T}"/cupsd || die
	sed -i -e "s/@neededservices@/${neededservices}/" "${T}"/cupsd || die
	doinitd "${T}"/cupsd

	if use pam ; then
		rm "${ED}"/etc/pam.d/${PN} || die
		pamd_mimic_system cups auth account
	fi

	if use xinetd ; then
		# Correct path
		sed -i -e "s:server = .*:server = /usr/libexec/cups/daemon/cups-lpd:" \
			"${ED}"/etc/xinetd.d/cups-lpd || die
		# It is safer to disable this by default, bug #137130
		grep -w 'disable' "${ED}"/etc/xinetd.d/cups-lpd || \
			{ sed -i -e "s:}:\tdisable = yes\n}:" "${ED}"/etc/xinetd.d/cups-lpd || die ; }
		# Write permission for file owner (root), bug #296221
		fperms u+w /etc/xinetd.d/cups-lpd
	else
		# Always configure with --with-xinetd= and clean up later,
		# bug #525604
		rm -r "${ED}"/etc/xinetd.d || die
	fi

	keepdir /etc/cups/{interfaces,ppd,ssl}

	if ! use X ; then
		rm -r "${ED}"/usr/share/applications || die
	fi

	# Create /etc/cups/client.conf, bug #196967 and bug #266678
	echo "ServerName ${EPREFIX}/run/cups/cups.sock" >> "${ED}"/etc/cups/client.conf

	# The following file is now provided by cups-filter:
	rm -r "${ED}"/usr/share/cups/banners || die

	# The following are created by the init script
	rm -r "${ED}"/var/cache || die
	rm -r "${ED}"/run || die

	keepdir /usr/libexec/cups/driver /usr/share/cups/{model,profiles} /var/log/cups /var/spool/cups/tmp
}

pkg_postinst() {
	xdg_pkg_postinst
	local v

	for v in ${REPLACING_VERSIONS}; do
		if ! ver_test ${v} -ge 2.2.2-r2 ; then
			ewarn "The cupsd init script switched to using pidfiles. Shutting down"
			ewarn "cupsd will fail the next time. To fix this, please run once as root"
			ewarn "   killall cupsd ; /etc/init.d/cupsd zap ; /etc/init.d/cupsd start"
			break
		fi
	done

	for v in ${REPLACING_VERSIONS}; do
		elog
		elog "For information about installing a printer and general cups setup"
		elog "take a look at: https://wiki.gentoo.org/wiki/Printing"
		break
	done

	optfeature_header "CUPS may need installing the following for certain features to work:"
	use zeroconf && optfeature "local hostname resolution using a hostname.local naming scheme" sys-auth/nss-mdns
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic linux-info xdg multilib-minimal pam systemd toolchain-funcs

MY_PV="${PV/_rc/rc}"
MY_PV="${MY_PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/apple/cups.git"
	if [[ ${PV} != 9999 ]]; then
		EGIT_BRANCH=branch-${PV/.9999}
	fi
else
	#SRC_URI="https://github.com/apple/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI="https://github.com/apple/cups/releases/download/v${MY_PV}/${MY_P}-source.tar.gz"
	if [[ "${PV}" != *_beta* ]] && [[ "${PV}" != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc ~x86 ~m68k-mint"
	fi
fi

DESCRIPTION="The Common Unix Printing System"
HOMEPAGE="https://www.cups.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="acl dbus debug kerberos lprng-compat pam selinux +ssl static-libs systemd +threads usb X xinetd zeroconf"

CDEPEND="
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
	!lprng-compat? ( !net-print/lprng )
	pam? ( sys-libs/pam )
	ssl? ( >=net-libs/gnutls-2.12.23-r6:0=[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd )
	usb? ( virtual/libusb:1 )
	X? ( x11-misc/xdg-utils )
	xinetd? ( sys-apps/xinetd )
	zeroconf? ( >=net-dns/avahi-0.6.31-r2[${MULTILIB_USEDEP}] )
"

DEPEND="${CDEPEND}"
BDEPEND="
	acct-group/lp
	acct-group/lpadmin
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

RDEPEND="${CDEPEND}
	acct-group/lp
	acct-group/lpadmin
	selinux? ( sec-policy/selinux-cups )
"

PDEPEND=">=net-print/cups-filters-1.0.43"

REQUIRED_USE="
	usb? ( threads )
"

# upstream includes an interactive test which is a nono for gentoo
RESTRICT="test"

# systemd-socket.patch from Fedora
PATCHES=(
	"${FILESDIR}/${PN}-2.2.6-fix-install-perms.patch"
	"${FILESDIR}/${PN}-1.4.4-nostrip.patch"
	"${FILESDIR}/${PN}-2.0.2-rename-systemd-service-files.patch"
	"${FILESDIR}/${PN}-2.0.1-xinetd-installation-fix.patch"
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/cups-config
)

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	#enewgroup lp -> acct-group/lp
	# user lp already provided by baselayout
	#enewuser lp -1 -1 -1 lp
	#enewgroup lpadmin 106

	if use kernel_linux; then
		linux-info_pkg_setup
		if  ! linux_config_exists; then
			ewarn "Can't check the linux kernel configuration."
			ewarn "You might have some incompatible options enabled."
		else
			# recheck that we don't have usblp to collide with libusb; this should now work in most cases (bug 501122)
			if use usb; then
				if linux_chkconfig_present USB_PRINTER; then
					elog "Your USB printers will be managed via libusb. In case you run into problems, "
					elog "please try disabling USB_PRINTER support in your kernel or blacklisting the"
					elog "usblp kernel module."
					elog "Alternatively, just disable the usb useflag for cups (your printer will still work)."
				fi
			else
				#here we should warn user that he should enable it so he can print
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

	# Remove ".SILENT" rule for verbose output (bug 524338).
	sed 's#^.SILENT:##g' -i "${S}"/Makedefs.in || die "sed failed"

	# Fix install-sh, posix sh does not have 'function'.
	sed 's#function gzipcp#gzipcp()#g' -i "${S}/install-sh"

	# Do not add -Werror even for live ebuilds
	sed '/WARNING_OPTIONS/s@-Werror@@' \
		-i config-scripts/cups-compiler.m4 || die

	AT_M4DIR=config-scripts eaclocal
	eautoconf

	# custom Makefiles
	multilib_copy_sources
}

multilib_src_configure() {
	export DSOFLAGS="${LDFLAGS}"

	einfo LINGUAS=\"${LINGUAS}\"

	# explicitly specify compiler wrt bug 524340
	#
	# need to override KRB5CONFIG for proper flags
	# https://github.com/apple/cups/issues/4423
	local myeconfargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		KRB5CONFIG="${EPREFIX}"/usr/bin/${CHOST}-krb5-config
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--localstatedir="${EPREFIX}"/var
		--with-exe-file-perm=755
		--with-rundir="${EPREFIX}"/run/cups
		--with-cups-user=lp
		--with-cups-group=lp
		--with-docdir="${EPREFIX}"/usr/share/cups/html
		--with-languages="${LINGUAS}"
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
		$(use_enable threads)
		$(use_enable ssl gnutls)
		$(use_enable systemd)
		$(multilib_native_use_enable usb libusb)
		$(use_enable zeroconf avahi)
		--disable-dnssd
		$(multilib_is_native_abi && echo --enable-libpaper || echo --disable-libpaper)
	)

	if tc-is-static-only; then
		myeconfargs+=(
			--disable-shared
		)
	fi

	econf "${myeconfargs[@]}"

	# install in /usr/libexec always, instead of using /usr/lib/cups, as that
	# makes more sense when facing multilib support.
	sed -i -e "s:SERVERBIN.*:SERVERBIN = \"\$\(BUILDROOT\)${EPREFIX}/usr/libexec/cups\":" Makedefs || die
	sed -i -e "s:#define CUPS_SERVERBIN.*:#define CUPS_SERVERBIN \"${EPREFIX}/usr/libexec/cups\":" config.h || die
	sed -i -e "s:cups_serverbin=.*:cups_serverbin=\"${EPREFIX}/usr/libexec/cups\":" cups-config || die

	# additional path corrections needed for prefix, see bug 597728
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

	# move the default config file to docs
	dodoc "${ED}"/etc/cups/cupsd.conf.default
	rm -f "${ED}"/etc/cups/cupsd.conf.default

	# clean out cups init scripts
	rm -rf "${ED}"/etc/{init.d/cups,rc*,pam.d/cups}

	# install our init script
	local neededservices=(
		$(usex zeroconf avahi-daemon '')
		$(usex dbus dbus '')
	)
	[[ -n ${neededservices[@]} ]] && neededservices="need ${neededservices[@]}"
	cp "${FILESDIR}"/cupsd.init.d-r3 "${T}"/cupsd || die
	sed -i \
		-e "s/@neededservices@/${neededservices}/" \
		"${T}"/cupsd || die
	doinitd "${T}"/cupsd

	# install our pam script
	pamd_mimic_system cups auth account

	if use xinetd ; then
		# correct path
		sed -i \
			-e "s:server = .*:server = /usr/libexec/cups/daemon/cups-lpd:" \
			"${ED}"/etc/xinetd.d/cups-lpd || die
		# it is safer to disable this by default, bug #137130
		grep -w 'disable' "${ED}"/etc/xinetd.d/cups-lpd || \
			{ sed -i -e "s:}:\tdisable = yes\n}:" "${ED}"/etc/xinetd.d/cups-lpd || die ; }
		# write permission for file owner (root), bug #296221
		fperms u+w /etc/xinetd.d/cups-lpd
	else
		# always configure with --with-xinetd= and clean up later,
		# bug #525604
		rm -rf "${ED}"/etc/xinetd.d
	fi

	keepdir /usr/libexec/cups/driver /usr/share/cups/{model,profiles} \
		/var/log/cups /var/spool/cups/tmp

	keepdir /etc/cups/{interfaces,ppd,ssl}

	if ! use X ; then
		rm -r "${ED}"/usr/share/applications || die
	fi

	# create /etc/cups/client.conf, bug #196967 and #266678
	echo "ServerName ${EPREFIX}/run/cups/cups.sock" >> "${ED}"/etc/cups/client.conf

	# the following file is now provided by cups-filters:
	rm -r "${ED}"/usr/share/cups/banners || die

	# the following are created by the init script
	rm -r "${ED}"/var/cache/cups || die
	rm -r "${ED}"/run || die

	# for the special case of running lprng and cups together, bug 467226
	if use lprng-compat ; then
		rm -fv "${ED}"/usr/bin/{lp*,cancel}
		rm -fv "${ED}"/usr/sbin/lp*
		rm -fv "${ED}"/usr/share/man/man1/{lp*,cancel*}
		rm -fv "${ED}"/usr/share/man/man8/lp*
		ewarn "Not installing lp... binaries, since the lprng-compat useflag is set."
		ewarn "Unless you plan to install an exotic server setup, you most likely"
		ewarn "do not want this. Disable the useflag then and all will be fine."
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	# Update desktop file database and gtk icon cache (bug 370059)
	xdg_pkg_postinst

	local v

	for v in ${REPLACING_VERSIONS}; do
		if ! ver_test ${v} -ge 2.2.2-r2 ; then
			echo
			ewarn "The cupsd init script switched to using pidfiles. Shutting down"
			ewarn "cupsd will fail the next time. To fix this, please run once as root"
			ewarn "   killall cupsd ; /etc/init.d/cupsd zap ; /etc/init.d/cupsd start"
			echo
			break
		fi
	done

	for v in ${REPLACING_VERSIONS}; do
		echo
		elog "For information about installing a printer and general cups setup"
		elog "take a look at: https://wiki.gentoo.org/wiki/Printing"
		echo
		break
	done
}

pkg_postrm() {
	# Update desktop file database and gtk icon cache (bug 370059)
	xdg_pkg_postrm
}

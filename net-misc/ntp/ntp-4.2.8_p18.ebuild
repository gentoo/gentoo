# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic systemd tmpfiles

MY_P=${P/_p/p}
DESCRIPTION="Network Time Protocol suite/programs"
HOMEPAGE="https://www.ntp.org/"
SRC_URI="https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-${PV:0:3}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="HPND BSD ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="caps debug openntpd parse-clocks readline samba selinux snmp ssl +threads vim-syntax zeroconf"

DEPEND="
	>=dev-libs/libevent-2.0.9:=[threads(+)?]
	readline? ( >=sys-libs/readline-4.1:= )
	kernel_linux? ( caps? ( sys-libs/libcap ) )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
	snmp? ( net-analyzer/net-snmp )
	ssl? ( dev-libs/openssl:= )
	parse-clocks? ( net-misc/pps-tools )
"
RDEPEND="
	${DEPEND}
	acct-group/ntp
	acct-user/ntp
	selinux? ( sec-policy/selinux-ntp )
	vim-syntax? ( app-vim/ntp-syntax )
	!net-misc/ntpsec
	!openntpd? ( !net-misc/openntpd )
"
BDEPEND="
	acct-group/ntp
	acct-user/ntp
	virtual/pkgconfig
"
PDEPEND="openntpd? ( net-misc/openntpd )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.8_p18-ipc-caps.patch # bug #533966
	"${FILESDIR}"/${PN}-4.2.8-sntp-test-pthreads.patch # bug #563922
	"${FILESDIR}"/${PN}-4.2.8_p14-add_cap_ipc_lock.patch # bug #711530
	"${FILESDIR}"/${PN}-4.2.8_p15-configure-clang16.patch
)

src_prepare() {
	default

	# Make sure every build uses the same install layout, bug #539092
	find sntp/loc/ -type f '!' -name legacy -delete || die

	# bug #622754
	eautoreconf

	# Disable pointless checks.
	touch .checkChangeLog .gcc-warning FRC.html html/.datecheck || die
}

src_configure() {
	# Ancient codebase, lto-type-mismatch in testsuite in packetProcesisng.c
	# where patching it then needs Ruby.
	filter-lto

	# bug #264109
	append-cppflags -D_GNU_SOURCE

	# https://bugs.gentoo.org/922508
	append-lfs-flags

	# avoid libmd5/libelf
	export ac_cv_search_MD5Init=no ac_cv_header_md5_h=no
	export ac_cv_lib_elf_nlist=no
	# blah, no real configure options #176333
	export ac_cv_header_dns_sd_h=$(usex zeroconf)
	export ac_cv_lib_dns_sd_DNSServiceRegister=${ac_cv_header_dns_sd_h}
	# Unity builds, we don't really need support for it, bug #804109
	export PATH_RUBY=/bin/false

	local myeconfargs=(
		--cache-file="${S}"/config.cache

		--with-lineeditlibs=readline,edit,editline
		--with-yielding-select
		--disable-local-libevent

		# Increase the default memlimit from 32MiB to 128MiB, bug #533232
		--with-memlock=256

		# Avoid overriding the user's toolchain settings, bug #895802
		--with-hardenfile=/dev/null

		$(use_enable caps linuxcaps)
		$(use_enable parse-clocks)
		$(use_enable debug debugging)
		$(use_with readline lineeditlibs readline)
		$(use_enable samba ntp-signd)
		$(use_with snmp ntpsnmpd)
		$(use_with ssl crypto)
		$(use_enable threads thread-support)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# Move ntpd/ntpdate to sbin, bug #66671
	dodir /usr/sbin
	mv "${ED}"/usr/bin/{ntpd,ntpdate} "${ED}"/usr/sbin/ || die "move to sbin"

	dodoc INSTALL WHERE-TO-START

	insinto /etc
	doins "${FILESDIR}"/ntp.conf

	newinitd "${FILESDIR}"/ntpd.rc-r2 ntpd
	newconfd "${FILESDIR}"/ntpd.confd ntpd
	newinitd "${FILESDIR}"/ntp-client.rc ntp-client
	newconfd "${FILESDIR}"/ntp-client.confd ntp-client
	newinitd "${FILESDIR}"/sntp.rc sntp
	newconfd "${FILESDIR}"/sntp.confd sntp
	if ! use caps ; then
		sed -i "s|-u ntp:ntp||" "${ED}"/etc/conf.d/ntpd || die
	fi
	sed -i "s:/usr/bin:/usr/sbin:" "${ED}"/etc/init.d/ntpd || die

	if use openntpd ; then
		cd "${ED}" || die
		rm usr/sbin/ntpd || die
		rm etc/{conf,init}.d/ntpd || die
		rm usr/share/man/man1/ntpd.1 || die
	else
		newtmpfiles "${FILESDIR}"/ntp.tmpfiles ntp.conf
		systemd_newunit "${FILESDIR}"/ntpd.service-r2 ntpd.service
		if use caps ; then
			sed -i '/ExecStart/ s|$| -u ntp:ntp|' \
				"${D}$(systemd_get_systemunitdir)"/ntpd.service \
				|| die
		fi
		systemd_enable_ntpunit 60-ntpd ntpd.service
	fi

	systemd_newunit "${FILESDIR}"/ntpdate.service-r2 ntpdate.service
	systemd_install_serviced "${FILESDIR}"/ntpdate.service.conf
	systemd_newunit "${FILESDIR}"/sntp.service-r3 sntp.service
	systemd_install_serviced "${FILESDIR}"/sntp.service.conf
}

pkg_postinst() {
	if ! use openntpd; then
		tmpfiles_process ntp.conf
	fi

	if grep -qs '^[^#].*notrust' "${EROOT}"/etc/ntp.conf ; then
		eerror "The notrust option was found in your /etc/ntp.conf!"
		ewarn "If your ntpd starts sending out weird responses,"
		ewarn "then make sure you have keys properly setup and see"
		ewarn "https://bugs.gentoo.org/41827"
	fi
}

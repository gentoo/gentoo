# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs flag-o-matic user systemd

MY_P=${P/_p/p}
DESCRIPTION="Network Time Protocol suite/programs"
HOMEPAGE="http://www.ntp.org/"
SRC_URI="http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-${PV:0:3}/${MY_P}.tar.gz
	https://dev.gentoo.org/~polynomial-c/${MY_P}-manpages.tar.xz"

LICENSE="HPND BSD ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~m68k-mint"
IUSE="caps debug ipv6 libressl openntpd parse-clocks readline samba selinux snmp ssl +threads vim-syntax zeroconf"

CDEPEND="readline? ( >=sys-libs/readline-4.1:0= )
	>=dev-libs/libevent-2.0.9:=[threads?]
	kernel_linux? ( caps? ( sys-libs/libcap ) )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
	snmp? ( net-analyzer/net-snmp )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl )
	)
	parse-clocks? ( net-misc/pps-tools )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-ntp )
	vim-syntax? ( app-vim/ntp-syntax )
	!net-misc/ntpsec
	!openntpd? ( !net-misc/openntpd )
"
PDEPEND="openntpd? ( net-misc/openntpd )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.8-ipc-caps.patch #533966
	"${FILESDIR}"/${PN}-4.2.8-sntp-test-pthreads.patch #563922
	"${FILESDIR}"/${PN}-4.2.8_p10-fix-build-wo-ssl-or-libressl.patch
	"${FILESDIR}"/${PN}-4.2.8_p12-libressl-2.8.patch
)

pkg_setup() {
	enewgroup ntp 123
	enewuser ntp 123 -1 /dev/null ntp
}

src_prepare() {
	default
	append-cppflags -D_GNU_SOURCE #264109
	# Make sure every build uses the same install layout. #539092
	find sntp/loc/ -type f '!' -name legacy -delete || die
	eautoreconf #622754
	# Disable pointless checks.
	touch .checkChangeLog .gcc-warning FRC.html html/.datecheck
}

src_configure() {
	# avoid libmd5/libelf
	export ac_cv_search_MD5Init=no ac_cv_header_md5_h=no
	export ac_cv_lib_elf_nlist=no
	# blah, no real configure options #176333
	export ac_cv_header_dns_sd_h=$(usex zeroconf)
	export ac_cv_lib_dns_sd_DNSServiceRegister=${ac_cv_header_dns_sd_h}
	# Increase the default memlimit from 32MiB to 128MiB.  #533232
	local myeconfargs=(
		--with-lineeditlibs=readline,edit,editline
		--with-yielding-select
		--disable-local-libevent
		--docdir='$(datarootdir)'/doc/${PF}
		--htmldir='$(docdir)/html'
		--with-memlock=256
		$(use_enable caps linuxcaps)
		$(use_enable parse-clocks)
		$(use_enable ipv6)
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
	# move ntpd/ntpdate to sbin #66671
	dodir /usr/sbin
	mv "${ED%/}"/usr/bin/{ntpd,ntpdate} "${ED%/}"/usr/sbin/ || die "move to sbin"

	dodoc INSTALL WHERE-TO-START
	doman "${WORKDIR}"/man/*.[58]

	insinto /etc
	doins "${FILESDIR}"/ntp.conf
	use ipv6 || sed -i '/^restrict .*::1/d' "${ED%/}"/etc/ntp.conf #524726
	newinitd "${FILESDIR}"/ntpd.rc-r1 ntpd
	newconfd "${FILESDIR}"/ntpd.confd ntpd
	newinitd "${FILESDIR}"/ntp-client.rc ntp-client
	newconfd "${FILESDIR}"/ntp-client.confd ntp-client
	newinitd "${FILESDIR}"/sntp.rc sntp
	newconfd "${FILESDIR}"/sntp.confd sntp
	if ! use caps ; then
		sed -i "s|-u ntp:ntp||" "${ED%/}"/etc/conf.d/ntpd || die
	fi
	sed -i "s:/usr/bin:/usr/sbin:" "${ED%/}"/etc/init.d/ntpd || die

	keepdir /var/lib/ntp
	use prefix || fowners ntp:ntp /var/lib/ntp

	if use openntpd ; then
		cd "${ED}" || die
		rm usr/sbin/ntpd || die
		rm -r var/lib || die
		rm etc/{conf,init}.d/ntpd || die
		rm usr/share/man/*/ntpd.8 || die
	else
		systemd_newunit "${FILESDIR}"/ntpd.service-r2 ntpd.service
		if use caps ; then
			sed -i '/ExecStart/ s|$| -u ntp:ntp|' \
				"${D%/}$(systemd_get_systemunitdir)"/ntpd.service \
				|| die
		fi
		systemd_enable_ntpunit 60-ntpd ntpd.service
	fi

	systemd_newunit "${FILESDIR}"/ntpdate.service-r1 ntpdate.service
	systemd_install_serviced "${FILESDIR}"/ntpdate.service.conf
	systemd_newunit "${FILESDIR}"/sntp.service-r2 sntp.service
	systemd_install_serviced "${FILESDIR}"/sntp.service.conf
}

pkg_postinst() {
	if grep -qs '^[^#].*notrust' "${EROOT}"/etc/ntp.conf ; then
		eerror "The notrust option was found in your /etc/ntp.conf!"
		ewarn "If your ntpd starts sending out weird responses,"
		ewarn "then make sure you have keys properly setup and see"
		ewarn "https://bugs.gentoo.org/41827"
	fi
}

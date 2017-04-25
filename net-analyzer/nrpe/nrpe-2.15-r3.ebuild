# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils systemd toolchain-funcs multilib user autotools

DESCRIPTION="Nagios Remote Plugin Executor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="command-args minimal selinux ssl tcpd"

DEPEND="ssl? ( dev-libs/openssl:0 )
	!minimal? ( tcpd? ( sys-apps/tcp-wrappers ) )"
RDEPEND="${DEPEND}
	!minimal? (
		|| ( net-analyzer/nagios-plugins net-analyzer/monitoring-plugins )
	)
	selinux? ( sec-policy/selinux-nagios )"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /dev/null nagios

	elog "If you plan to use \"nrpe_check_control\" then you may want to specify"
	elog "different command and services files. You can override the defaults"
	elog "through the \"NAGIOS_COMMAND_FILE\" and \"NAGIOS_SERVICES_FILE\" environment variables."
	elog "NAGIOS_COMMAND_FILE=${NAGIOS_COMMAND_FILE:-/var/rw/nagios.cmd}"
	elog "NAGIOS_SERVICES_FILE=${NAGIOS_SERVICES_FILE:-/etc/services.cfg}"
}

src_prepare() {
	# Add support for large output,
	# http://opsview-blog.opsera.com/dotorg/2008/08/enhancing-nrpe.html
	epatch "${FILESDIR}"/${PN}-2.14-multiline.patch

	# fix configure, among others #326367, #397603
	epatch "${FILESDIR}"/${PN}-2.15-tcpd-et-al.patch

	# otherwise autoconf will overwrite the custom include/config.h.in
	epatch "${FILESDIR}"/${PN}-2.15-autoconf-header.patch

	# improve handling of metachars for security
	epatch "${FILESDIR}"/${PN}-2.15-metachar-security-fix.patch

	# Fix build with USE="-ssl".
	epatch "${FILESDIR}"/${PN}-2.15-no-ssl.patch

	sed -i -e '/define \(COMMAND\|SERVICES\)_FILE/d' \
		contrib/nrpe_check_control.c || die

	# change the default location of the pid file
	sed -i -e '/pid_file/s:/var/run:/run:' sample-config/nrpe.cfg.in || die

	# fix TFU handling of autoheader
	sed -i -e '/#undef/d' include/config.h.in || die

	eautoreconf
}

src_configure() {
	local myconf
	if use minimal; then
		myconf="--disable-tcp-wrapper --disable-command-args"
	else
		myconf="$(use_enable tcpd tcp-wrapper) $(use_enable command-args)"
	fi

	econf \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios \
		--with-nrpe-user=nagios \
		--with-nrpe-group=nagios \
		$(use_enable ssl) \
		${myconf}
}

src_compile() {
	emake -C src check_nrpe $(use minimal || echo nrpe)

	# Add nifty nrpe check tool
	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} \
		-DCOMMAND_FILE=\"${NAGIOS_COMMAND_FILE:-/var/rw/nagios.cmd}\" \
		-DSERVICES_FILE=\"${NAGIOS_SERVICES_FILE:-/etc/services.cfg}\" \
		${LDFLAGS} -o nrpe_check_control contrib/nrpe_check_control.c || die
}

src_install() {
	dodoc LEGAL Changelog README SECURITY \
		contrib/README.nrpe_check_control \
		$(use ssl && echo README.SSL)

	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe src/check_nrpe nrpe_check_control

	use minimal && return 0

	## NON-MINIMAL INSTALL FOLLOWS ##

	insinto /etc/nagios
	newins sample-config/nrpe.cfg nrpe.cfg
	fowners root:nagios /etc/nagios/nrpe.cfg
	fperms 0640 /etc/nagios/nrpe.cfg

	exeinto /usr/libexec
	doexe src/nrpe

	newinitd "${FILESDIR}"/nrpe.init nrpe
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/xinetd.d/
	newins "${FILESDIR}/nrpe.xinetd.2" nrpe

	if use tcpd; then
		sed -i -e '/^reload()/, /^}/ d' -e '/extra_started_commands/s:reload::' \
			"${D}"/etc/init.d/nrpe
	fi
}

pkg_postinst() {
	elog "If you are using the nrpe daemon, remember to edit"
	elog "the config file /etc/nagios/nrpe.cfg"

	if use command-args ; then
		ewarn ""
		ewarn "You have enabled command-args for NRPE. This enables"
		ewarn "the ability for clients to supply arguments to commands"
		ewarn "which should be run. "
		ewarn "THIS IS CONSIDERED A SECURITY RISK!"
		ewarn "Please read /usr/share/doc/${PF}/SECURITY.bz2 for more info"
	fi
}

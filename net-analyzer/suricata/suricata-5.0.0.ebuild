# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools linux-info python-single-r1 systemd

DESCRIPTION="High performance Network IDS, IPS and Network Security Monitoring engine"
HOMEPAGE="https://suricata-ids.org/"
SRC_URI="https://www.openinfosecfoundation.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+af-packet bpf control-socket cuda debug +detection geoip hardened logrotate lua luajit lz4 nflog +nfqueue redis +rules systemd test tools"

RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( lua luajit )
	bpf? ( af-packet )
	tools? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="acct-group/suricata
	acct-user/suricata
	dev-libs/jansson
	dev-libs/libpcre
	dev-libs/libyaml
	net-libs/libnet:*
	net-libs/libnfnetlink
	dev-libs/nspr
	dev-libs/nss
	>=net-libs/libhtp-0.5.31
	net-libs/libpcap
	sys-apps/file
	sys-libs/libcap-ng
	bpf?        ( >=dev-libs/libbpf-0.0.5 )
	cuda?       ( dev-util/nvidia-cuda-toolkit )
	geoip?      ( dev-libs/libmaxminddb )
	logrotate?  ( app-admin/logrotate )
	lua?        ( dev-lang/lua:* )
	luajit?     ( dev-lang/luajit:* )
	lz4?        ( app-arch/lz4 )
	nflog?      ( net-libs/libnetfilter_log )
	nfqueue?    ( net-libs/libnetfilter_queue )
	redis?      ( dev-libs/hiredis )
	tools?      ( dev-python/pyyaml[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	dev-lang/rust"
# Not confirmed that it works yet
#	test? ( dev-util/coccinelle )"
RDEPEND="${CDEPEND}
	tools? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.0_configure-lua-flags.patch"
	"${FILESDIR}/${PN}-5.0.0_configure-no-lz4-automagic.patch"
	"${FILESDIR}/${PN}-5.0.0_default-config.patch"
)

pkg_pretend() {
	if use bpf && use kernel_linux; then
		if kernel_is -lt 4 15; then
			ewarn "Kernel 4.15 or newer is necessary to use all XDP features like the CPU redirect map"
		fi

		CONFIG_CHECK="~XDP_SOCKETS"
		ERROR_XDP_SOCKETS="CONFIG_XDP_SOCKETS is not set, making it impossible for Suricata will to load XDP programs. "
		ERROR_XDP_SOCKETS+="Other eBPF features should work normally."
		check_extra_config
	fi
}

src_prepare() {
	default
	sed -ie 's/docdir =.*/docdir = ${datarootdir}\/doc\/'${PF}'\//' "${S}/doc/Makefile.am"
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		"--localstatedir=/var" \
		"--enable-non-bundled-htp" \
		"--enable-gccmarch-native=no" \
		$(use_enable af-packet) \
		$(use_enable bpf ebpf) \
		$(use_enable control-socket unix-socket) \
		$(use_enable cuda) \
		$(use_enable detection) \
		$(use_enable geoip) \
		$(use_enable hardened gccprotect) \
		$(use_enable hardened pie) \
		$(use_enable lua) \
		$(use_enable luajit) \
		$(use_enable lz4) \
		$(use_enable nflog) \
		$(use_enable nfqueue) \
		$(use_enable redis hiredis) \
		$(use_enable test coccinelle) \
		$(use_enable test unittests) \
		$(use_enable tools python)
	)

	if use debug; then
		myeconfargs+=( $(use_enable debug) )
		# so we can get a backtrace according to "reporting bugs" on upstream web site
		CFLAGS="-ggdb -O0" econf ${myeconfargs[@]}
	else
		econf ${myeconfargs[@]}
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use bpf; then
		rm -f ebpf/Makefile.{am,in}
		dodoc -r ebpf/
		keepdir /usr/libexec/suricata/ebpf
	fi

	insinto "/etc/${PN}"
	doins etc/{classification,reference}.config threshold.config suricata.yaml

	if use rules; then
		insinto "/etc/${PN}/rules"
		doins rules/*.rules
	fi

	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"

	fowners -R ${PN}: "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"
	fperms 750 "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"

	newinitd "${FILESDIR}/${PN}-5.0.0-init" ${PN}
	newconfd "${FILESDIR}/${PN}-5.0.0-conf" ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfiles ${PN}.conf

	if use logrotate; then
		insopts -m0644
		insinto /etc/logrotate.d
		newins etc/${PN}.logrotate ${PN}
	fi
}

pkg_postinst() {
	if ! use systemd; then
		elog "The ${PN} init script expects to find the path to the configuration"
		elog "file as well as extra options in /etc/conf.d."
		elog ""
		elog "To create more than one ${PN} service, simply create a new .yaml file for it"
		elog "then create a symlink to the init script from a link called"
		elog "${PN}.foo - like so"
		elog "   cd /etc/${PN}"
		elog "   ${EDITOR##*/} suricata-foo.yaml"
		elog "   cd /etc/init.d"
		elog "   ln -s ${PN} ${PN}.foo"
		elog "Then edit /etc/conf.d/${PN} and make sure you specify sensible options for foo."
		elog ""
		elog "You can create as many ${PN}.foo* services as you wish."
	fi

	if use bpf; then
		elog "eBPF/XDP files must be compiled (using sys-devel/clang[llvm_targets_BPF]) before use"
		elog "because their configuration is hard-coded. You can find the default ones in"
		elog "    ${EPREFIX}/usr/share/doc/${PF}"
		elog "and the common location for eBPF bytecode is"
		elog "    ${EPREFIX}/usr/libexec/${PN}"
		elog "For more information, see https://${PN}.readthedocs.io/en/${P}/capture-hardware/ebpf-xdp.html"
	fi

	if use logrotate; then
		elog "You enabled the logrotate USE flag. Please make sure you correctly set up the ${PN} logrotate config file in /etc/logrotate.d/."
	fi

	if use debug; then
		elog "You enabled the debug USE flag. Please read this link to report bugs upstream:"
		elog "https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Reporting_Bugs"
		elog "You need to also ensure the FEATURES variable in make.conf contains the"
		elog "'nostrip' option to produce useful core dumps or back traces."
	fi
}

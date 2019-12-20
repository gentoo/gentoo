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
IUSE="+af-packet bpf control-socket cuda debug +detection geoip hardened logrotate lua luajit lz4 nflog +nfqueue redis systemd test"

RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( lua luajit )
	bpf? ( af-packet )"

CDEPEND="acct-group/suricata
	acct-user/suricata
	dev-libs/jansson
	dev-libs/libpcre
	dev-libs/libyaml
	net-libs/libnet:*
	net-libs/libnfnetlink
	dev-libs/nspr
	dev-libs/nss
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=net-libs/libhtp-0.5.32
	net-libs/libpcap
	sys-apps/file
	sys-libs/libcap-ng
	bpf?        ( >=dev-libs/libbpf-0.0.6 )
	cuda?       ( dev-util/nvidia-cuda-toolkit )
	geoip?      ( dev-libs/libmaxminddb )
	logrotate?  ( app-admin/logrotate )
	lua?        ( dev-lang/lua:* )
	luajit?     ( dev-lang/luajit:* )
	lz4?        ( app-arch/lz4 )
	nflog?      ( net-libs/libnetfilter_log )
	nfqueue?    ( net-libs/libnetfilter_queue )
	redis?      ( dev-libs/hiredis )"
DEPEND="${CDEPEND}
	>=sys-devel/autoconf-2.69-r5
	virtual/rust"
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.1_configure-no-lz4-automagic.patch"
	"${FILESDIR}/${PN}-5.0.1_default-config.patch"
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
		"--runstatedir=/run" \
		"--enable-non-bundled-htp" \
		"--enable-gccmarch-native=no" \
		"--enable-python" \
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
		$(use_enable test unittests) \
		"--disable-coccinelle"
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
	python_optimize

	if use bpf; then
		rm -f ebpf/Makefile.{am,in}
		dodoc -r ebpf/
		keepdir /usr/libexec/suricata/ebpf
	fi

	insinto "/etc/${PN}"
	doins etc/{classification,reference}.config threshold.config suricata.yaml

	keepdir "/var/lib/${PN}/rules" "/var/lib/${PN}/update"
	keepdir "/var/log/${PN}"

	fowners -R ${PN}: "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"
	fperms 750 "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"
	fperms 2750 "/var/lib/${PN}/rules" "/var/lib/${PN}/update"

	newinitd "${FILESDIR}/${PN}-5.0.1-init" ${PN}
	newconfd "${FILESDIR}/${PN}-5.0.1-conf" ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfiles ${PN}.conf

	if use logrotate; then
		insopts -m0644
		insinto /etc/logrotate.d
		newins etc/${PN}.logrotate ${PN}
	fi
}

pkg_postinst() {
	elog ""
	if use systemd; then
		elog "Suricata requires either the mode of operation (e.g. --af-packet) or the interface to listen on (e.g. -i eth0)"
		elog "to be specified on the command line. The provided systemd unit launches Suricata in af-packet mode and relies"
		elog "on file configuration to specify interfaces, should you prefer to run it differently you will have to customise"
		elog "said unit. The simplest way of doing it is to override the Environment=OPTIONS='...' line using a .conf file"
		elog "placed in the directory ${EPREFIX}/etc/systemd/system/suricata.service.d/ ."
		elog "For details, see the section on drop-in directories in systemd.unit(5)."
	else
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
		elog ""
		elog "eBPF/XDP files must be compiled (using sys-devel/clang[llvm_targets_BPF]) before use"
		elog "because their configuration is hard-coded. You can find the default ones in"
		elog "    ${EPREFIX}/usr/share/doc/${PF}/ebpf"
		elog "and the common location for eBPF bytecode is"
		elog "    ${EPREFIX}/usr/libexec/${PN}"
		elog "For more information, see https://${PN}.readthedocs.io/en/${P}/capture-hardware/ebpf-xdp.html"
	fi

	if use debug; then
		elog ""
		elog "You have enabled the debug USE flag. Please read this link to report bugs upstream:"
		elog "https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Reporting_Bugs"
		elog "You need to also ensure the FEATURES variable in make.conf contains the"
		elog "'nostrip' option to produce useful core dumps or back traces."
	fi

	elog ""
	elog "To download and install an initial set of rules, run:"
	elog "    emerge --config =${CATEGORY}/${PF}"
	elog ""
}

pkg_config() {
	suricata-update
}

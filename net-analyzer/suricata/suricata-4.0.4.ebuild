# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils user

DESCRIPTION="High performance Network IDS, IPS and Network Security Monitoring engine"
HOMEPAGE="https://suricata-ids.org/"
SRC_URI="https://www.openinfosecfoundation.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+af-packet control-socket cuda debug +detection geoip hardened logrotate lua luajit nflog +nfqueue redis +rules test"

DEPEND="
	>=dev-libs/jansson-2.2
	dev-libs/libpcre
	dev-libs/libyaml
	net-libs/libnet:*
	net-libs/libnfnetlink
	dev-libs/nspr
	dev-libs/nss
	>=net-libs/libhtp-0.5.20
	net-libs/libpcap
	sys-apps/file
	cuda?       ( dev-util/nvidia-cuda-toolkit )
	geoip?      ( dev-libs/geoip )
	lua?        ( dev-lang/lua:* )
	luajit?     ( dev-lang/luajit:* )
	nflog?      ( net-libs/libnetfilter_log )
	nfqueue?    ( net-libs/libnetfilter_queue )
	redis?      ( dev-libs/hiredis )
	logrotate?      ( app-admin/logrotate )
	sys-libs/libcap-ng
"
# #446814
#	prelude?    ( dev-libs/libprelude )
#	pfring?     ( sys-process/numactl net-libs/pf_ring)
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} "${PN}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}_configure-lua-flags.patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		"--localstatedir=/var/" \
		"--enable-non-bundled-htp" \
		$(use_enable af-packet) \
		$(use_enable detection) \
		$(use_enable nfqueue) \
		$(use_enable test coccinelle) \
		$(use_enable test unittests) \
		$(use_enable control-socket unix-socket)
	)

	if use cuda ; then
		myeconfargs+=( $(use_enable cuda) )
	fi
	if use geoip ; then
		myeconfargs+=( $(use_enable geoip) )
	fi
	if use hardened ; then
		myeconfargs+=( $(use_enable hardened gccprotect) )
	fi
	if use nflog ; then
		myeconfargs+=( $(use_enable nflog) )
	fi
	if use redis ; then
		myeconfargs+=( $(use_enable redis hiredis) )
	fi
	# not supported yet (no pfring in portage)
# 	if use pfring ; then
# 		myeconfargs+=( $(use_enable pfring) )
# 	fi
	# no libprelude in portage
# 	if use prelude ; theng
# 		myeconfargs+=( $(use_enable prelude) )
# 	fi
	if use lua ; then
		myeconfargs+=( $(use_enable lua) )
	fi
	if use luajit ; then
		myeconfargs+=( $(use_enable luajit) )
	fi
	if (use !lua) && (use !luajit) ; then
		myeconfargs+=(
			--disable-lua
			--disable-luajit
		)
	fi

# this should be used when pf_ring use flag support will be added
# 	LIBS+="-lrt -lnuma"

	# avoid upstream configure script trying to add -march=native to CFLAGS
	myeconfargs+=( --enable-gccmarch-native=no )

	if use debug ; then
		myeconfargs+=( $(use_enable debug) )
		# so we can get a backtrace according to "reporting bugs" on upstream web site
		CFLAGS="-ggdb -O0" econf LIBS="${LIBS}" ${myeconfargs[@]}
	else
		econf LIBS="${LIBS}" ${myeconfargs[@]}
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	insinto "/etc/${PN}"
	doins {classification,reference,threshold}.config suricata.yaml

	if use rules ; then
		insinto "/etc/${PN}/rules"
		doins rules/*.rules
	fi

	dodir "/var/lib/${PN}"
	dodir "/var/log/${PN}"

	fowners -R ${PN}: "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"
	fperms 750 "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"

	newinitd "${FILESDIR}/${PN}-4.0.3-init" ${PN}
	newconfd "${FILESDIR}/${PN}-4.0.3-conf" ${PN}

	if use logrotate; then
		insopts -m0644
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/${PN}-logrotate ${PN}
	fi
}

pkg_postinst() {
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

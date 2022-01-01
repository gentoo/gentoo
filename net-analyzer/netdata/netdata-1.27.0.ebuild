# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )

inherit autotools fcaps linux-info python-single-r1 systemd

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/netdata/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/netdata/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Linux real time system monitoring, done right!"
HOMEPAGE="https://github.com/netdata/netdata https://my-netdata.io/"

LICENSE="GPL-3+ MIT BSD"
SLOT="0"
IUSE="caps +compression cpu_flags_x86_sse2 cups +dbengine ipmi +jsonc kinesis +lto mongodb mysql nfacct nodejs postgres prometheus +python tor xen"
REQUIRED_USE="
	mysql? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	tor? ( python )"

# most unconditional dependencies are for plugins.d/charts.d.plugin:
RDEPEND="
	acct-group/netdata
	acct-user/netdata
	app-misc/jq
	>=app-shells/bash-4:0
	|| (
		net-analyzer/openbsd-netcat
		net-analyzer/netcat
	)
	net-libs/libwebsockets
	net-misc/curl
	net-misc/wget
	sys-apps/util-linux
	virtual/awk
	caps? ( sys-libs/libcap )
	cups? ( net-print/cups )
	dbengine? (
		app-arch/lz4
		dev-libs/judy
		dev-libs/openssl:=
	)
	dev-libs/libuv
	compression? ( sys-libs/zlib )
	ipmi? ( sys-libs/freeipmi )
	jsonc? ( dev-libs/json-c:= )
	kinesis? ( dev-libs/aws-sdk-cpp[kinesis] )
	mongodb? ( dev-libs/mongo-c-driver )
	nfacct? (
		net-firewall/nfacct
		net-libs/libmnl
	)
	nodejs? ( net-libs/nodejs )
	prometheus? (
		dev-libs/protobuf:=
		app-arch/snappy
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]')
		mysql? ( $(python_gen_cond_dep 'dev-python/mysqlclient[${PYTHON_MULTI_USEDEP}]') )
		postgres? ( $(python_gen_cond_dep 'dev-python/psycopg:2[${PYTHON_MULTI_USEDEP}]') )
		tor? ( $(python_gen_cond_dep 'net-libs/stem[${PYTHON_MULTI_USEDEP}]') )
	)
	xen? (
		app-emulation/xen-tools
		dev-libs/yajl
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

FILECAPS=(
	'cap_dac_read_search,cap_sys_ptrace+ep' 'usr/libexec/netdata/plugins.d/apps.plugin'
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# --disable-cloud: https://github.com/netdata/netdata/issues/8961
	econf \
		--localstatedir="${EPREFIX}"/var \
		--with-user=netdata \
		--disable-cloud \
		$(use_enable jsonc) \
		$(use_enable cups plugin-cups) \
		$(use_enable dbengine) \
		$(use_enable nfacct plugin-nfacct) \
		$(use_enable ipmi plugin-freeipmi) \
		$(use_enable kinesis backend-kinesis) \
		$(use_enable lto lto) \
		$(use_enable mongodb backend-mongodb) \
		$(use_enable prometheus backend-prometheus-remote-write) \
		$(use_enable xen plugin-xenstat) \
		$(use_enable cpu_flags_x86_sse2 x86-sse) \
		$(use_with compression zlib)
}

src_install() {
	default

	rm -rf "${D}/var/cache" || die

	keepdir /var/log/netdata
	fowners -Rc netdata:netdata /var/log/netdata
	keepdir /var/lib/netdata
	keepdir /var/lib/netdata/registry
	fowners -Rc netdata:netdata /var/lib/netdata

	fowners -Rc root:netdata /usr/share/${PN}

	newinitd system/netdata-openrc ${PN}
	systemd_dounit system/netdata.service
	insinto /etc/netdata
	doins system/netdata.conf
}

pkg_postinst() {
	fcaps_pkg_postinst

	if use xen ; then
		fcaps 'cap_dac_override' 'usr/libexec/netdata/plugins.d/xenstat.plugin'
	fi
}

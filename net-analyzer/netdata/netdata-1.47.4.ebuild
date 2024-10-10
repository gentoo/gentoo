# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python{3_9,3_10,3_11,3_12} )

inherit cmake fcaps linux-info optfeature python-single-r1 systemd

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/netdata/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/netdata/${PN}/releases/download/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Linux real time system monitoring, done right!"
HOMEPAGE="https://github.com/netdata/netdata https://my-netdata.io/"

LICENSE="GPL-3+ MIT BSD"
SLOT="0"
IUSE="aclk bpf cloud cups +dbengine ipmi mongodb mysql nfacct nodejs postgres prometheus +python systemd tor xen"
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
	app-alternatives/awk
	sys-libs/libcap
	cups? ( net-print/cups )
	app-arch/lz4:=
	app-arch/zstd:=
	app-arch/brotli:=
	dbengine? (
		dev-libs/judy
		dev-libs/openssl:=
	)
	dev-libs/libpcre2:=
	dev-libs/libuv:=
	dev-libs/libyaml
	dev-libs/protobuf:=
	bpf? ( virtual/libelf:= )
	sys-libs/zlib
	ipmi? ( sys-libs/freeipmi )
	dev-libs/json-c:=
	mongodb? ( dev-libs/mongo-c-driver )
	nfacct? (
		net-firewall/nfacct
		net-libs/libmnl:=
	)
	nodejs? ( net-libs/nodejs )
	prometheus? (
		app-arch/snappy:=
		dev-libs/protobuf:=
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
		mysql? ( $(python_gen_cond_dep 'dev-python/mysqlclient[${PYTHON_USEDEP}]') )
		postgres? ( $(python_gen_cond_dep 'dev-python/psycopg:2[${PYTHON_USEDEP}]') )
		tor? ( $(python_gen_cond_dep 'net-libs/stem[${PYTHON_USEDEP}]') )
	)
	xen? (
		app-emulation/xen-tools
		dev-libs/yajl
	)
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

FILECAPS=(
	'cap_dac_read_search,cap_sys_ptrace+ep'
	'usr/libexec/netdata/plugins.d/apps.plugin'
	'usr/libexec/netdata/plugins.d/debugfs.plugin'
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	linux-info_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=TRUE
		-DCMAKE_INSTALL_PREFIX=/
		-DENABLE_ACLK=$(usex aclk)
		-DENABLE_CLOUD=$(usex cloud)
		-DENABLE_DBENGINE=$(usex dbengine)
		-DENABLE_PLUGIN_CUPS=$(usex cups)
		-DENABLE_PLUGIN_NFACCT=$(usex nfacct)
		-DENABLE_PLUGIN_FREEIPMI=$(usex ipmi)
		-DENABLE_EXPORTER_MONGODB=$(usex mongodb)
		-DENABLE_EXPORTER_PROMETHEUS_REMOTE_WRITE=$(usex prometheus)
		-DENABLE_PLUGIN_XENSTAT=$(usex xen)
		-DENABLE_PLUGIN_EBPF=$(usex bpf)
		-DENABLE_PLUGIN_GO=FALSE
		-DENABLE_PLUGIN_SYSTEMD_JOURNAL=$(usex systemd)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm -rf "${D}/var/cache" || die
	rm -rf "${D}/var/run" || die

	keepdir /var/log/netdata
	fowners -Rc netdata:netdata /var/log/netdata
	keepdir /var/lib/netdata
	keepdir /var/lib/netdata/registry
	keepdir /var/lib/netdata/cloud.d
	fowners -Rc netdata:netdata /var/lib/netdata

	newinitd "${D}/usr/lib/netdata/system/openrc/init.d/netdata" "${PN}"
	newconfd "${D}/usr/lib/netdata/system/openrc/conf.d/netdata" "${PN}"
	systemd_newunit "${D}/usr/lib/netdata/system/systemd/netdata.service.v235" netdata.service
	systemd_dounit "${D}/usr/lib/netdata/system/systemd/netdata-updater.service"
	systemd_dounit "${D}/usr/lib/netdata/system/systemd/netdata-updater.timer"
	insinto /etc/netdata
	doins system/netdata.conf
}

pkg_postinst() {
	fcaps_pkg_postinst

	if use nfacct ; then
		fcaps 'cap_net_admin' 'usr/libexec/netdata/plugins.d/nfacct.plugin'
	fi

	if use xen ; then
		fcaps 'cap_dac_override' 'usr/libexec/netdata/plugins.d/xenstat.plugin'
	fi

	if use ipmi ; then
	    fcaps 'cap_dac_override' 'usr/libexec/netdata/plugins.d/freeipmi.plugin'
	fi

	optfeature "go.d external plugin" net-analyzer/netdata-go-plugin
}

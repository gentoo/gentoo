# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit fcaps linux-info python-r1 systemd user

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/firehol/${PN}.git"
	inherit git-r3 autotools
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://firehol.org/download/${PN}/releases/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Linux real time system monitoring, done right!"
HOMEPAGE="https://github.com/firehol/netdata https://my-netdata.io/"

LICENSE="GPL-3+ MIT BSD"
SLOT="0"
IUSE="+compression cpu_flags_x86_sse2 mysql nfacct nodejs +python"
REQUIRED_USE="
	mysql? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"
# most unconditional dependencies are for plugins.d/charts.d.plugin:
RDEPEND="
	>=app-shells/bash-4:0
	net-misc/curl
	net-misc/wget
	virtual/awk
	net-libs/libmnl
	|| ( net-analyzer/netcat6 net-analyzer/netcat )
	net-analyzer/tcpdump
	net-analyzer/traceroute
	compression? ( sys-libs/zlib )
	python? (
		${PYTHON_DEPS}
		dev-python/pyyaml[${PYTHON_USEDEP}]
		mysql? (
			|| ( dev-python/mysqlclient[${PYTHON_USEDEP}] dev-python/mysql-python[${PYTHON_USEDEP}] )
		)
	)
	nfacct? (
		net-firewall/nfacct
		net-libs/libmnl
	)
	nodejs? (
		net-libs/nodejs
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

: ${NETDATA_USER:=netdata}
: ${NETDATA_GROUP:=netdata}

FILECAPS=(
	'cap_dac_read_search,cap_sys_ptrace+ep' 'usr/libexec/netdata/plugins.d/apps.plugin'
)

pkg_setup() {
	linux-info_pkg_setup

	enewgroup ${PN}
	enewuser ${PN} -1 -1 / ${PN}
}

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--with-user=${NETDATA_USER} \
		$(use_enable nfacct plugin-nfacct) \
		$(use_enable cpu_flags_x86_sse2 sse) \
		$(use_with compression zlib)
}

src_install() {
	default

	fowners ${NETDATA_USER}:${NETDATA_GROUP} /var/log/netdata
	fowners ${NETDATA_USER}:${NETDATA_GROUP} /var/cache/netdata

	fowners -Rc ${NETDATA_USER}:${NETDATA_GROUP} /usr/share/${PN}

	newinitd system/netdata-openrc ${PN}
	systemd_dounit system/netdata.service
}

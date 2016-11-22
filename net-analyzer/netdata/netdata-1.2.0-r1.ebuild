# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info systemd user fcaps

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
IUSE="+compression nfacct nodejs"

# most unconditional dependencies are for plugins.d/charts.d.plugin:
RDEPEND="
	>=app-shells/bash-4:0
	net-misc/curl
	net-misc/wget
	virtual/awk
	compression? ( sys-libs/zlib )
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
		$(use_with compression zlib)
}

src_install() {
	default

	fowners ${NETDATA_USER}:${NETDATA_GROUP} /var/log/netdata
	fowners ${NETDATA_USER}:${NETDATA_GROUP} /var/cache/netdata

	chown -Rc ${NETDATA_USER}:${NETDATA_GROUP} "${ED}"/usr/share/${PN} || die

	newinitd system/netdata-openrc ${PN}
	systemd_dounit system/netdata.service
}

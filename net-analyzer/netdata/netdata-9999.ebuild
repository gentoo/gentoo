# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )

inherit autotools fcaps linux-info python-r1 systemd user

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
IUSE="caps +compression cpu_flags_x86_sse2 ipmi mysql nfacct nodejs postgres +python tor"
REQUIRED_USE="
	mysql? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	tor? ( python )"

# most unconditional dependencies are for plugins.d/charts.d.plugin:
RDEPEND="
	>=app-shells/bash-4:0
	|| (
		net-analyzer/openbsd-netcat
		net-analyzer/netcat6
		net-analyzer/netcat
	)
	net-analyzer/tcpdump
	net-analyzer/traceroute
	net-misc/curl
	net-misc/wget
	sys-apps/util-linux
	virtual/awk
	caps? ( sys-libs/libcap )
	compression? ( sys-libs/zlib )
	ipmi? ( sys-libs/freeipmi )
	nfacct? (
		net-firewall/nfacct
		net-libs/libmnl
	)
	nodejs? ( net-libs/nodejs )
	python? (
		${PYTHON_DEPS}
		dev-python/pyyaml[${PYTHON_USEDEP}]
		mysql? (
			|| (
				dev-python/mysqlclient[${PYTHON_USEDEP}]
				dev-python/mysql-python[${PYTHON_USEDEP}]
			)
		)
		postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		tor? ( net-libs/stem[${PYTHON_USEDEP}] )
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
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		--with-user=${NETDATA_USER} \
		$(use_enable nfacct plugin-nfacct) \
		$(use_enable ipmi plugin-freeipmi) \
		$(use_enable cpu_flags_x86_sse2 x86-sse) \
		$(use_with compression zlib)
}

src_install() {
	default

	rm -rf "${D}/var/cache" || die

	# Remove unneeded .keep files
	find "${ED}" -name ".keep" -delete || die

	fowners -Rc ${NETDATA_USER}:${NETDATA_GROUP} /var/log/netdata
	keepdir /var/log/netdata
	fowners -Rc ${NETDATA_USER}:${NETDATA_GROUP} /var/lib/netdata
	keepdir /var/lib/netdata
	keepdir /var/lib/netdata/registry

	fowners -Rc root:${NETDATA_GROUP} /usr/share/${PN}

	newinitd system/netdata-openrc ${PN}
	systemd_dounit system/netdata.service
	insinto /etc/netdata
	doins system/netdata.conf
}

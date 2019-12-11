# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1

MY_PN="Pacemaker"
MY_P=${MY_PN}-${PV/_/-}

DESCRIPTION="Pacemaker CRM"
HOMEPAGE="http://www.linux-ha.org/wiki/Pacemaker"
SRC_URI="https://github.com/ClusterLabs/${PN}/archive/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE="acl heartbeat smtp snmp static-libs"

DEPEND="${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	sys-cluster/cluster-glue
	>=sys-cluster/libqb-0.14.0
	sys-cluster/resource-agents
	heartbeat? ( >=sys-cluster/heartbeat-3.0.0 )
	!heartbeat? ( sys-cluster/corosync )
	smtp? ( net-libs/libesmtp )
	snmp? ( net-analyzer/net-snmp )
"
RDEPEND="${DEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S="${WORKDIR}/${PN}-${MY_P}"

src_prepare() {
	default
	sed -i -e "s/ -ggdb//g" configure.ac || die
	eautoreconf
	python_fix_shebang .
}

src_configure() {
	local myopts=""
	if use heartbeat ; then
		myopts="--without-corosync"
	else
		myopts="--with-ais"
	fi
	# appends lib to localstatedir automatically
	econf \
		--libdir=/usr/$(get_libdir) \
		--localstatedir=/var \
		--disable-dependency-tracking \
		--disable-fatal-warnings \
		$(use_with acl) \
		--without-cs-quorum \
		--without-cman \
		$(use_with heartbeat) \
		$(use_with smtp esmtp) \
		$(use_with snmp) \
		$(use_enable static-libs static) \
		${myopts}
}

src_install() {
	default
	rm -rf "${D}"/var/run "${D}"/etc/init.d
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	if has_version "<sys-cluster/corosync-2.0"; then
		insinto /etc/corosync/service.d
		newins "${FILESDIR}/${PN}.service" ${PN}
	fi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..10} )

inherit autotools python-single-r1

MY_P="${PN^}-${PV/_/-}"

DESCRIPTION="Pacemaker CRM"
HOMEPAGE="http://www.linux-ha.org/wiki/Pacemaker"
SRC_URI="https://github.com/ClusterLabs/${PN}/archive/${MY_P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+ BSD CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="acl smtp snmp"

DEPEND="
	${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-cluster/cluster-glue-1.0.12-r1
	>=sys-cluster/libqb-2.0.0:=
	sys-cluster/resource-agents
	sys-cluster/corosync
	smtp? ( net-libs/libesmtp )
	snmp? ( net-analyzer/net-snmp )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${PN}-${MY_P}"

src_prepare() {
	default
	sed -i -e "s/ -ggdb//g" configure.ac || die
	eautoreconf
}

src_configure() {
	# appends lib to localstatedir automatically
	local myconf=(
		--with-ocfdir=/usr/$(get_libdir)/ocf
		--localstatedir=/var
		--disable-fatal-warnings
		--disable-static
		--without-cs-quorum
		--without-cman
		--without-heartbeat
		--with-corosync
		--with-ais
		$(use_with acl)
		$(use_with smtp esmtp)
		$(use_with snmp)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	python_optimize

	# remove provided initd file as we need support for OpenRC
	rm -rf "${ED}/etc/init.d" || die "Failed to remove old initd"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	keepdir /var/lib/pacemaker/{blackbox,cib,cores,pengine}
	keepdir /var/log/pacemaker/bundles

	find "${ED}" -name '*.la' -delete || die
}

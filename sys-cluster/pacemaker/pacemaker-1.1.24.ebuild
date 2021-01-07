# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit autotools python-single-r1

MY_PN="${PN^}"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="Pacemaker CRM"
HOMEPAGE="http://www.linux-ha.org/wiki/Pacemaker"
SRC_URI="https://github.com/ClusterLabs/${PN}/archive/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="acl smtp snmp"

DEPEND="${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	sys-cluster/cluster-glue
	sys-cluster/corosync
	>=sys-cluster/libqb-0.14.0
	sys-cluster/resource-agents

	smtp?		( net-libs/libesmtp )
	snmp?		( net-analyzer/net-snmp )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.24-python-fixes.patch
	"${FILESDIR}"/${PN}-1.1.24-qa-warnings.patch
)

S="${WORKDIR}/${PN}-${MY_P}"

src_prepare() {
	default
	sed -i -e "s/ -ggdb//g" configure.ac || die
	eautoreconf
	python_fix_shebang .
}

src_configure() {
	# appends lib to localstatedir automatically
	local myconf=(
		--localstatedir=/var
		--disable-fatal-warnings
		--disable-static
		--without-cs-quorum
		--without-cman
		$(use_with acl)
		--without-heartbeat
		$(use_with smtp esmtp)
		$(use_with snmp)
		--with-ais
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	rm -rf "${D}/var/run" "${D}/etc/init.d"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	if has_version "<sys-cluster/corosync-2.0"; then
		insinto /etc/corosync/service.d
		newins "${FILESDIR}/${PN}.service" "${PN}"
	fi
	find "${D}" -name '*.la' -delete || die

	keepdir /var/lib/pacemaker/{blackbox,cib,cores,pengine}
	python_optimize
}

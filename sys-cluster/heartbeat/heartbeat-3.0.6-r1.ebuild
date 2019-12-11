# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

DESCRIPTION="Heartbeat high availability cluster manager"
HOMEPAGE="http://www.linux-ha.org/wiki/Heartbeat"
SRC_URI="http://hg.linux-ha.org/${PN}-STABLE_3_0/archive/STABLE-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="doc snmp static-libs"

RDEPEND="sys-cluster/cluster-glue
	dev-libs/glib:2
	virtual/ssh
	net-libs/gnutls
	snmp? ( net-analyzer/net-snmp )
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-lang/swig
	doc? ( dev-libs/libxslt app-text/docbook-xsl-stylesheets )"

PDEPEND="sys-cluster/resource-agents"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/Heartbeat-3-0-STABLE-${PV}

PATCHES=(
	"${FILESDIR}/3.0.6-r1-configure.patch"
	"${FILESDIR}/3.0.6-docs.patch"
	"${FILESDIR}/3.0.4-python_tests.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup

	ewarn "If you're upgrading from heartbeat-2.x please follow:"
	ewarn "https://www.gentoo.org/proj/en/cluster/ha-cluster/heartbeat-upgrade.xml"
}

src_prepare() {
	default
	eautoreconf

	cp "${FILESDIR}"/3.0.6-r1-heartbeat-init "${WORKDIR}"/heartbeat-init || die
	sed -i \
		-e "s:HA_LIB_DIR=/usr/lib/:HA_LIB_DIR=/usr/$(get_libdir)/:g" \
		"${WORKDIR}"/heartbeat-init || die
}

src_configure() {
	econf \
		--disable-fatal-warnings \
		$(use_enable static-libs static) \
		$(use_enable doc) \
		--disable-tipc \
		--enable-dopd \
		$(use_enable snmp)
}

src_install() {
	default

	newinitd "${WORKDIR}/heartbeat-init" heartbeat

	# fix collisions
	rm -rf "${D}"/usr/include/heartbeat/{compress,ha_msg}.h || die

	if ! use static-libs; then
		find "${D}" -name "*.la" -delete || die
	fi

	if use doc ; then
		dodoc README doc/*.txt doc/AUTHORS
	fi
}

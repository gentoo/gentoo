# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils

HOMEPAGE="https://github.com/linux-rdma/opensm/"
DESCRIPTION="OpenSM - InfiniBand Subnet Manager and Administration for OpenIB"

SRC_URI="https://github.com/linux-rdma/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="tools"
SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

DEPEND="sys-cluster/rdma-core"
RDEPEND="$DEPEND
	 tools? (
		net-misc/iputils
		net-misc/openssh
	)"

PATCHES=( "${FILESDIR}/${PN}-3.3.17-sldd.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-perf-mgr \
		--enable-default-event-plugin \
		--with-osmv="openib"
}

src_install() {
	default
	newconfd "${FILESDIR}/opensm.conf.d" opensm
	newinitd "${FILESDIR}/opensm.init.d.2" opensm
	insinto /etc/logrotate.d
	newins "${S}/scripts/opensm.logrotate" opensm
	# we dont need this int script
	rm "${ED}/etc/init.d/opensmd" || die "Dropping of upstream initscript failed"

	if use tools; then
		dosbin scripts/sldd.sh
		newconfd "${FILESDIR}/sldd.conf.d" sldd
		newinitd "${FILESDIR}/sldd.init.d" sldd
	fi
}

pkg_postinst() {
	einfo "To automatically configure the infiniband subnet manager on boot,"
	einfo "edit /etc/opensm.conf and add opensm to your start-up scripts:"
	einfo "\`rc-update add opensm default\`"
}

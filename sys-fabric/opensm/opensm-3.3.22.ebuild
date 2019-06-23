# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OFED_VER="4.17-1"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="${PV}"

inherit autotools eutils systemd openib

DESCRIPTION="OpenSM - InfiniBand Subnet Manager and Administration for OFED"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="static-libs tools"

DEPEND="sys-fabric/rdma-core:="
RDEPEND="$DEPEND
	tools? (
		net-misc/iputils
		net-misc/openssh
	)"
block_other_ofed_versions

PATCHES=(
	"${FILESDIR}"/opensm-3.3.22-norpm.patch
	"${FILESDIR}"/opensm-3.3.22-sldd.patch
)

src_prepare() {
	eapply "${PATCHES[@]}"
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-perf-mgr
		--enable-default-event-plugin
		--with-osmv="openib"
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newconfd "${FILESDIR}/opensm.conf.d" opensm
	newinitd "${FILESDIR}/opensm.init.d" opensm
	insinto /etc/logrotate.d
	newins "${S}/scripts/opensm.logrotate" opensm
	# we dont nee this int script
	rm "${ED}/etc/init.d/opensmd" || die "Dropping of upstream initscript failed"

	if use tools; then
		dosbin scripts/sldd.sh
		newconfd "${FILESDIR}/sldd.conf.d" sldd
		newinitd "${FILESDIR}/sldd.init.d" sldd

		insinto /etc
		newins "${FILESDIR}/sldd.conf.d" sldd.conf
		systemd_dounit "${FILESDIR}/sldd.service"
	fi

	systemd_dounit "${FILESDIR}/opensm.service"
}

pkg_postinst() {
	einfo "To automatically configure the infiniband subnet manager on boot,"
	einfo "edit /etc/opensm.conf and add opensm to your start-up scripts:"
	einfo "\`rc-update add opensm default\`"
}

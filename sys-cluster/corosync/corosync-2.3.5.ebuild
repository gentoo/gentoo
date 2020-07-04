# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_TREE="56ae8fe"

DESCRIPTION="OSI Certified implementation of a complete cluster engine"
HOMEPAGE="http://www.corosync.org/"
SRC_URI="http://build.clusterlabs.org/corosync/releases/${P}.tar.gz"

LICENSE="BSD-2 public-domain"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="doc infiniband static-libs systemd xml"

# TODO: support those new configure flags
# --enable-augeas : Install the augeas lens for corosync.conf
# --enable-snmp : SNMP protocol support
# --enable-watchdog : Watchdog support
RDEPEND="!sys-cluster/heartbeat
	infiniband? (
		sys-fabric/libibverbs:*
		sys-fabric/librdmacm:*
	)
	dev-libs/nss
	>=sys-cluster/libqb-0.14.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( sys-apps/groff )"

PATCHES=( "${FILESDIR}/${PN}-2.3.4-docs.patch" )

DOCS=( README.recovery SECURITY AUTHORS )

S="${WORKDIR}/${PN}-${PN}-${MY_TREE}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	default
	# appends lib to localstatedir automatically
	# FIXME: install just shared libs --disable-static does not work
	econf_opts=(
		--localstatedir=/var \
		$(use_enable infiniband rdma) \
		$(use_enable systemd) \
		$(use_enable xml xmlconf)
	)
	use doc && econf_opts+=( --enable-doc )
	econf "${econf_opts[@]}"
}

src_install() {
	default
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	if use systemd; then
		rm "${D}"/lib/systemd/system/corosync-notifyd.service || die
	else
		rm "${D}"/etc/init.d/corosync-notifyd || die
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	keepdir /var/lib/corosync
	use static-libs || rm -rf "${D}"/usr/$(get_libdir)/*.{,l}a || die

}

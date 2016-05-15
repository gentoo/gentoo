# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools base

MY_TREE="4dc01e3"

DESCRIPTION="OSI Certified implementation of a complete cluster engine"
HOMEPAGE="http://www.corosync.org/"
SRC_URI="http://build.clusterlabs.org/corosync/releases/${P}.tar.gz"

LICENSE="BSD-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="doc infiniband static-libs"

# TODO: support those new configure flags
# --enable-watchdog : Watchdog support
# --enable-augeas : Install the augeas lens for corosync.conf
# --enable-snmp : SNMP protocol support
# --enable-xmlconf : XML configuration support
# --enable-systemd : Install systemd service files
RDEPEND="!sys-cluster/heartbeat
	infiniband? (
		sys-infiniband/libibverbs
		sys-infiniband/librdmacm
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
	base_src_prepare
	eautoreconf
}

src_configure() {
	# appends lib to localstatedir automatically
	# FIXME: install just shared libs --disable-static does not work
	econf \
		--localstatedir=/var \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable doc) \
		$(use_enable infiniband rdma)
}

src_install() {
	default
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	rm "${D}"/etc/init.d/corosync-notifyd || die

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	keepdir /var/lib/corosync
	use static-libs || rm -rf "${D}"/usr/$(get_libdir)/*.{,l}a || die

}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} < 2.0 ]]; then
		ewarn "!! IMPORTANT !!"
		ewarn " "
		ewarn "Migrating from a previous version of corosync can be dangerous !"
		ewarn " "
		ewarn "Make sure you backup your cluster configuration before proceeding"
		ewarn " "
	fi
}

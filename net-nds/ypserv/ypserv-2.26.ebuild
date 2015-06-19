# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/ypserv/ypserv-2.26.ebuild,v 1.5 2012/03/02 21:10:36 ranger Exp $

EAPI="4"

inherit autotools

DESCRIPTION="Network Information Service server"
HOMEPAGE="http://www.linux-nis.org/nis/"
SRC_URI="mirror://kernel/linux/utils/net/NIS/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="slp"

DEPEND=">=sys-libs/gdbm-1.8.0
	 slp? ( net-libs/openslp )"
RDEPEND="${DEPEND}
	 || ( net-nds/rpcbind net-nds/portmap )"

src_prepare() {
	# The configure script does not provide a command-line flag to control usage
	# of slp. Use a brutal method in case we need to disable it.
	if ! use slp; then
		sed -i -e 's/USE_SLP=1/USE_SLP=0/g' configure.in || die
		eautoreconf
	fi
}

src_install() {
	default
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	insinto /etc
	doins etc/ypserv.conf etc/netgroup etc/netmasks
	insinto /var/yp
	newins etc/securenets securenets.default

	newconfd "${FILESDIR}/ypserv.confd" ypserv
	newconfd "${FILESDIR}/rpc.yppasswdd.confd" rpc.yppasswdd
	newconfd "${FILESDIR}/rpc.ypxfrd.confd" rpc.ypxfrd

	newinitd "${FILESDIR}/ypserv" ypserv
	newinitd "${FILESDIR}/rpc.yppasswdd-r1" rpc.yppasswdd
	newinitd "${FILESDIR}/rpc.ypxfrd-2.23" rpc.ypxfrd

	echo "CONFIG_PROTECT=\"/var/yp/Makefile\"" > "${T}"/10ypserv
	doenvd "${T}"/10ypserv
}

pkg_preinst() {
	# This ebuilds installs an env file which CONFIG_PROTECTs /var/yp/Makefile,
	# but if the user is migrating from older ypserv, this won't take effect
	# immediately. Keep the older setup with Makefile.dist file and ask the user
	# to migrate.
	if [ -f "${ROOT}/var/yp/Makefile.dist" ]; then
		mv "${D}/var/yp/Makefile" "${D}/var/yp/Makefile.dist" \
			|| die "mv failed"
		cp "${ROOT}/var/yp/Makefile" "${D}/var/yp/Makefile" \
			|| die "cp failed"
		elog "Please remove ${ROOT}/var/yp/Makefile.dist after making sure that"
		elog "${ROOT}/var/yp/Makefile looks fine to you. It is now"
		elog "CONFIG_PROTECTed, so further changes should be managed with"
		elog "usual config management tools like etc-update or dispatch-conf."
	fi
}

pkg_postinst() {
	einfo "To complete setup, you will need to edit /var/yp/securenets,"
	einfo "/etc/conf.d/ypserv, /etc/ypserv.conf, /etc/conf.d/rpc.yppasswdd"
	einfo "and possibly /var/yp/Makefile."

	einfo "To start the services at boot, you need to enable ypserv and optionally"
	einfo "the rpc.yppasswdd and/or rpc.ypxfrd services"
}

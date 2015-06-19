# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/rgmanager-agents/rgmanager-agents-3.9.2.ebuild,v 1.1 2011/09/14 10:51:29 ultrabug Exp $

EAPI=4

inherit multilib versionator

CLUSTER_RELEASE="3.1.5"
MY_PN="resource-agents"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Resource Manager Agents"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/r/e/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~sys-cluster/rgmanager-${CLUSTER_RELEASE}
	~sys-cluster/cman-${CLUSTER_RELEASE}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${P} \
		--libdir=/usr/$(get_libdir) \
		--localstatedir=/var \
		--sysconfdir=/etc \
		--with-ras-set=rgmanager
}

src_install() {
	default

	# remove useless RHEV check script and log directory
	rm -rf "${D}/usr/sbin" "${D}/var"
}

pkg_postinst() {
	if [[ "${ROOT}" != "/" ]] ; then
		ewarn "You have to run 'ccs_update_schema' in the chroot-environment"
		ewarn "to update the schema file for the cluster configuration."
		ewarn "Otherwise you will not be able to define ressources."
	else
		elog "Running ccs_update_schema to update the configuration file schema"
		/usr/sbin/ccs_update_schema -v -f
	fi
}

pkg_postrm() {
	if [[ "${ROOT}" != "/" ]] ; then
		ewarn "You have to run 'ccs_update_schema' in the chroot-environment"
		ewarn "to update the schema file for the cluster configuration."
		ewarn "Otherwise you may be able to define ressources even though they"
		ewarn "are not present anymore."
	else
		elog "Running ccs_update_schema to update the configuration file schema"
		/usr/sbin/ccs_update_schema -v -f
	fi
}

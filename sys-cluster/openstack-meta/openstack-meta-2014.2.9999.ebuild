# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/openstack-meta/openstack-meta-2014.2.9999.ebuild,v 1.2 2015/05/04 15:34:02 prometheanfire Exp $

EAPI=5

DESCRIPTION="A openstack meta-package for installing the various openstack pieces"
HOMEPAGE="https://openstack.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="keystone swift neutron glance cinder nova"

DEPEND=""
RDEPEND="keystone? ( ~sys-auth/keystone-2014.2.9999 )
		swift? ( ~sys-cluster/swift-2.2.2 )
		neutron? ( ~sys-cluster/neutron-2014.2.9999 )
		glance? ( ~app-admin/glance-2014.2.9999 )
		cinder? ( ~sys-cluster/cinder-2014.2.9999 )
		nova? ( ~sys-cluster/nova-2014.2.9999 )"

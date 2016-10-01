# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A openstack meta-package for installing the various openstack pieces"
HOMEPAGE="https://openstack.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="keystone swift neutron glance cinder nova"

DEPEND=""
RDEPEND="
	keystone? ( ~sys-auth/keystone-${PV} )
	swift? ( || ( ~sys-cluster/swift-2.9.0 ~sys-cluster/swift-2.10.0 ) )
	neutron? ( ~sys-cluster/neutron-${PV} )
	glance? ( ~app-admin/glance-${PV} )
	cinder? ( ~sys-cluster/cinder-${PV} )
	nova? ( ~sys-cluster/nova-${PV} )
"

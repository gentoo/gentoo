# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A openstack meta-package for installing the various openstack pieces"
HOMEPAGE="https://openstack.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cinder glance heat keystone neutron nova swift"

DEPEND=""
RDEPEND="
	keystone? ( ~sys-auth/keystone-${PV} )
	swift? ( ~sys-cluster/swift-${PV} )
	neutron? ( ~sys-cluster/neutron-${PV} )
	glance? ( ~app-admin/glance-${PV} )
	cinder? ( ~sys-cluster/cinder-${PV} )
	nova? ( ~sys-cluster/nova-${PV} )
	heat? ( ~sys-cluster/heat-${PV} )
"

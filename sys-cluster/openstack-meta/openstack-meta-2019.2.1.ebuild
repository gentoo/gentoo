# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A openstack meta-package for installing the various openstack pieces"
HOMEPAGE="https://openstack.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cinder glance heat keystone neutron nova placement swift"

if [[ ${PV} != *9999 ]];then
	KEYWORDS="amd64 ~arm64 x86"
fi

DEPEND=""
RDEPEND="
	keystone? ( ~sys-auth/keystone-16.0.0 )
	swift? ( ~sys-cluster/swift-2.23.1 )
	neutron? ( ~sys-cluster/neutron-15.0.0 )
	glance? ( ~app-admin/glance-19.0.0 )
	cinder? ( ~sys-cluster/cinder-15.0.0 )
	nova? ( ~sys-cluster/nova-20.0.1 )
	heat? ( ~sys-cluster/heat-13.0.0 )
	placement? ( ~sys-cluster/placement-2.0.0 )
"

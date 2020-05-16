# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A openstack meta-package for installing the various openstack pieces"
HOMEPAGE="https://openstack.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cinder glance heat keystone neutron nova placement swift"

if [[ ${PV} != *9999 ]];then
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DEPEND=""
RDEPEND="
	keystone? ( >=sys-auth/keystone-17.0.0
								<sys-auth/keystone-18 )
	swift? ( ~sys-cluster/swift-2.25.0 )
	neutron? ( >=sys-cluster/neutron-16.0.0
						<sys-cluster/neutron-17 )
	glance? ( >=app-admin/glance-20.0.0
						<app-admin/glance-21 )
	cinder? ( >=sys-cluster/cinder-16.0.0
						<sys-cluster/cinder-17 )
	nova? ( >=sys-cluster/nova-21.0.0
						<sys-cluster/nova-22 )
	heat? ( >=sys-cluster/heat-14.0.0
						<sys-cluster/heat-15 )
	placement? ( >=sys-cluster/placement-3.0.0
								<sys-cluster/placement-4 )
"

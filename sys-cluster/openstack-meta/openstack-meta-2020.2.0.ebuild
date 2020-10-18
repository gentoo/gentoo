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
	keystone? ( >=sys-auth/keystone-18.0.0
								<sys-auth/keystone-19 )
	swift? ( >=sys-cluster/swift-2.26.0
						<sys-cluster/swift-2.27.0 )
	neutron? ( >=sys-cluster/neutron-17.0.0
						<sys-cluster/neutron-18 )
	glance? ( >=app-admin/glance-21.0.0
						<app-admin/glance-22 )
	cinder? ( >=sys-cluster/cinder-17.0.0
						<sys-cluster/cinder-18 )
	nova? ( >=sys-cluster/nova-22.0.0
						<sys-cluster/nova-23 )
	heat? ( >=sys-cluster/heat-15.0.0
						<sys-cluster/heat-16 )
	placement? ( >=sys-cluster/placement-4.0.0
								<sys-cluster/placement-5 )
"

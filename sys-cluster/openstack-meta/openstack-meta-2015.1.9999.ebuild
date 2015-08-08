# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A openstack meta-package for installing the various openstack pieces"
HOMEPAGE="https://openstack.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="keystone swift neutron glance cinder nova"

DEPEND=""
RDEPEND="keystone? ( ~sys-auth/keystone-2015.1.9999 )
		swift? ( ~sys-cluster/swift-2.3.0 )
		neutron? ( ~sys-cluster/neutron-2015.1.9999 )
		glance? ( ~app-admin/glance-2015.1.9999 )
		cinder? ( ~sys-cluster/cinder-2015.1.9999 )
		nova? ( ~sys-cluster/nova-2015.1.9999 )"

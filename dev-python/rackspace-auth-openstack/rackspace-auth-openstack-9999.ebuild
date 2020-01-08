# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/emonty/${PN}.git"

DESCRIPTION="Rackspace Auth Plugin for OpenStack Clients"
HOMEPAGE="https://github.com/emonty/rackspace-auth-openstack"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

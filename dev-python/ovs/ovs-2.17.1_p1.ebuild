# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="OVS bindings for python"
HOMEPAGE="https://github.com/openvswitch/ovs/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

RDEPEND="dev-python/sortedcontainers[${PYTHON_USEDEP}]"

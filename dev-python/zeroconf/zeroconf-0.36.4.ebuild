# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P=python-zeroconf-${PV}
DESCRIPTION="Pure Python Multicast DNS Service Discovery Library (Bonjour/Avahi compatible)"
HOMEPAGE="
	https://github.com/jstasiak/python-zeroconf/
	https://pypi.org/project/zeroconf/"
SRC_URI="
	https://github.com/jstasiak/python-zeroconf/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-python/ifaddr-0.1.7[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# network
	tests/test_core.py::Framework::test_close_multiple_times
	tests/test_core.py::Framework::test_launch_and_close
	tests/test_core.py::Framework::test_launch_and_close_context_manager
	tests/test_core.py::Framework::test_launch_and_close_v4_v6
	tests/test_core.py::Framework::test_launch_and_close_v6_only
	tests/services/test_types.py::ServiceTypesQuery::test_integration_with_listener_ipv6
)

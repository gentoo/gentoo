# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 )
DISTUTILS_IN_SOURCE_BUILD=TRUE  # Needed due to versioned test patches

inherit distutils-r1

DESCRIPTION="OpenStack Orchestration API Client Library"
HOMEPAGE="http://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# NOTE: doc is broken due to pbr requiring a git checkout

# NOTE: dev-python/discover is not used in tests
# dev-python/discover[${PYTHON_USEDEP}]

CDEPEND="
	>=dev-python/pbr-0.6[${PYTHON_USEDEP}]
	!~dev-python/pbr-0.7[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
"
CRDEPEND="
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.1[${PYTHON_USEDEP}]
	!~dev-python/requests-2.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		${CRDEPEND}
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
		<dev-python/hacking-0.9[${PYTHON_USEDEP}]
		>=dev-python/httpretty-0.8.0[${PYTHON_USEDEP}]
		!~dev-python/httpretty-0.8.1[${PYTHON_USEDEP}]
		!~dev-python/httpretty-0.8.2[${PYTHON_USEDEP}]
		!~dev-python/httpretty-0.8.3[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	${CRDEPEND}
"

python_test() {
	# BUG: https://bugs.launchpad.net/python-heatclient/+bug/1313257
	ebegin 'patching heatclient/tests/test_common_http.py'
	sed \
		-e '651,/def/ d' \
		-i heatclient/tests/test_common_http.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	# BUG: https://bugs.launchpad.net/python-heatclient/+bug/1375035
	ebegin 'patching heatclient/tests/test_shell.py'
	sed \
		-e '1953,/def|@/ d' \
		-i heatclient/tests/test_shell.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	if [[ "${EPYTHON}" = "python3.3" ]]; then
		# BUG: https://bugs.launchpad.net/python-heatclient/+bug/1375047
		ebegin 'patching heatclient/tests/test_events.py'
		sed \
			-e '68,/def/ d' \
			-i heatclient/tests/test_events.py
		STATUS=$?
		eend ${STATUS}
		[[ ${STATUS} -gt 0 ]] && die

		# BUG: https://bugs.launchpad.net/python-heatclient/+bug/1375049
		ebegin 'patching heatclient/tests/test_events.py'
		sed \
			-e '111,/def/ d' \
			-e '53,/def/ d' \
			-i heatclient/tests/test_events.py
		STATUS=$?
		eend ${STATUS}
		[[ ${STATUS} -gt 0 ]] && die

		ebegin 'patching heatclient/tests/test_resources.py'
		sed \
			-e '69,/def/ d' \
			-i heatclient/tests/test_resources.py
		STATUS=$?
		eend ${STATUS}
		[[ ${STATUS} -gt 0 ]] && die

		# BUG: https://bugs.launchpad.net/python-heatclient/+bug/1375051
		ebegin 'patching heatclient/tests/test_template_utils.py'
		sed \
			-e '231,/def/ d' \
			-i heatclient/tests/test_template_utils.py
		STATUS=$?
		eend ${STATUS}
		[[ ${STATUS} -gt 0 ]] && die
	fi

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPYTHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

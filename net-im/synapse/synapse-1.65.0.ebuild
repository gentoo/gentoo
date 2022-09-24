# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1 multiprocessing optfeature systemd

DESCRIPTION="Reference implementation of Matrix homeserver"
HOMEPAGE="
	https://matrix.org/
	https://github.com/matrix-org/synapse/
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/matrix-org/${PN}.git"
else
	MY_PV="${PV/_rc/rc}"
	SRC_URI="https://github.com/matrix-org/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="amd64 ~ppc64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="postgres systemd test"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/synapse
	acct-group/synapse
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/bleach[${PYTHON_USEDEP}]
		dev-python/canonicaljson[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/frozendict[${PYTHON_USEDEP}]
		dev-python/ijson[${PYTHON_USEDEP}]
		>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		>=dev-python/matrix-common-1.2.1[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/netaddr[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/phonenumbers[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},webp]
		dev-python/prometheus_client[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/pymacaroons[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		dev-python/signedjson[${PYTHON_USEDEP}]
		dev-python/sortedcontainers[${PYTHON_USEDEP}]
		dev-python/treq[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/unpaddedbase64[${PYTHON_USEDEP}]
		postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		systemd? ( dev-python/python-systemd[${PYTHON_USEDEP}] )
	')
"
BDEPEND="
	test? ( $(python_gen_cond_dep '
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	') )
"

python_test() {
	"${EPYTHON}" -m twisted.trial -j "$(makeopts_jobs)" tests || die "Tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	keepdir /var/{lib,log}/synapse /etc/synapse
	fowners synapse:synapse /var/{lib,log}/synapse /etc/synapse
	fperms 0750 /var/{lib,log}/synapse /etc/synapse
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/synapse.service"
}

pkg_postinst() {
	optfeature "VoIP relaying on your homeserver with turn" net-im/coturn

	einfo "In order to generate initial configuration run:"
	einfo "sudo -u synapse synapse_homeserver \\"
	einfo "    --server-name matrix.domain.tld \\"
	einfo "    --config-path /etc/synapse/homeserver.yaml \\"
	einfo "    --generate-config \\"
	einfo "    --data-directory /var/lib/synapse \\"
	einfo "    --report-stats=no"
	einfo
	einfo "See also upgrade notes:"
	einfo "https://github.com/matrix-org/synapse/blob/develop/docs/upgrade.md"
}

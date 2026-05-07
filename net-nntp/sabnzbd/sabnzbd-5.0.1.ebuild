# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="sqlite"

inherit optfeature python-single-r1 systemd

MY_PV="${PV/_alpha/Alpha}"
MY_PV="${MY_PV/_beta/Beta}"
MY_PV="${MY_PV/_rc/RC}"

MY_P="SABnzbd-${MY_PV}"

DESCRIPTION="Binary newsgrabber with web-interface"
HOMEPAGE="https://sabnzbd.org/"
SRC_URI="https://github.com/sabnzbd/sabnzbd/releases/download/${MY_PV}/${MY_P}-src.tar.gz"
S="${WORKDIR}/${MY_P}"

# SABnzbd is GPL-2+ but bundles JS/CSS libraries and Python modules
# with their own licenses (Bootstrap, jQuery, Knockout, rarfile, etc).
LICENSE="GPL-2+ Apache-2.0 CC-BY-3.0 ISC LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	acct-user/sabnzbd
	acct-group/sabnzbd
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/apprise-1.9.2[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		>=dev-python/cheetah3-3.4.0[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		>=dev-python/feedparser-6.0.11[${PYTHON_USEDEP}]
		>=dev-python/guessit-3.8.0[${PYTHON_USEDEP}]
		dev-python/notify2[${PYTHON_USEDEP}]
		dev-python/portend[${PYTHON_USEDEP}]
		dev-python/puremagic[${PYTHON_USEDEP}]
		~dev-python/rarfile-4.2[${PYTHON_USEDEP}]
		~dev-python/sabctools-9.4.0[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
	|| (
		>=app-arch/par2cmdline-0.8
		>=app-arch/par2cmdline-turbo-1.1.0
	)
	net-misc/wget
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/flaky[${PYTHON_USEDEP}]
			dev-python/lxml[${PYTHON_USEDEP}]
			dev-python/pyfakefs[${PYTHON_USEDEP}]
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/pytest-httpbin[${PYTHON_USEDEP}]
			dev-python/pytest-httpserver[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/selenium[${PYTHON_USEDEP}]
			dev-python/tavalidate[${PYTHON_USEDEP}]
			>=dev-python/tavern-3[${PYTHON_USEDEP}]
			dev-python/werkzeug[${PYTHON_USEDEP}]
			dev-python/xmltodict[${PYTHON_USEDEP}]
		')
		app-arch/7zip
		app-arch/unrar
		app-arch/unzip
	)
"

src_test() {
	local EPYTEST_IGNORE=(
		# network sandbox
		tests/test_get_addrinfo.py
		tests/test_getipaddress.py
		tests/test_internetspeed.py
		# Requires chromedriver
		tests/test_functional_config.py
		tests/test_functional_downloads.py
		tests/test_functional_sorting.py
	)
	local EPYTEST_DESELECT=(
		# network sandbox
		'tests/test_cfg.py::TestValidators::test_validate_host'
		'tests/test_consistency.py::TestWiki'
		'tests/test_rss.py::TestRSS::test_rss_newznab_parser'
		'tests/test_rss.py::TestRSS::test_rss_nzedb_parser'
		'tests/test_urlgrabber.py::TestBuildRequest::test_http_basic'
		'tests/test_urlgrabber.py::TestBuildRequest::test_https_basic'
		# Requires chromedriver
		'tests/test_functional_misc.py::TestShowLogging::test_showlog'
		'tests/test_functional_misc.py::TestQueueRepair::test_queue_repair'
		'tests/test_functional_misc.py::TestDaemonizing::test_daemonizing'
		# Runs extract_pot.py which needs the git repo
		'tests/test_functional_misc.py::TestExtractPot::test_extract_pot'
	)

	epytest -s
}

src_install() {
	insinto /usr/share/${PN}
	doins -r email icons interfaces locale po sabnzbd scripts tools

	exeinto /usr/share/${PN}
	doexe SABnzbd.py

	python_fix_shebang "${ED}"/usr/share/${PN}
	python_optimize "${ED}"/usr/share/${PN}

	newinitd "${FILESDIR}"/${PN}-r1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	diropts -o ${PN} -g ${PN}
	dodir /etc/${PN}
	keepdir /var/log/${PN}

	insinto "/etc/${PN}"
	insopts -m 0600 -o "${PN}" -g "${PN}"
	newins "${FILESDIR}"/${PN}-r1.ini ${PN}.ini

	dodoc ISSUES.txt README.mkd

	systemd_newunit "${FILESDIR}"/sabnzbd_at.service 'sabnzbd@.service'
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		einfo "Default directory: /var/lib/${PN}"
		einfo
		einfo "To add a user to the sabnzbd group so it can edit SABnzbd+ files, run:"
		einfo
		einfo "    usermod -a -G sabnzbd <user>"
		einfo
		einfo "By default, SABnzbd will listen on TCP port 8080."
	fi

	optfeature "7z archive support" app-arch/7zip
	optfeature "rar archive support" app-arch/unrar app-arch/rar
	optfeature "zip archive support" app-arch/unzip
}

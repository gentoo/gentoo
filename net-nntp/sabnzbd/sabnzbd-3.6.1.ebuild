# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 systemd

MY_PV="${PV/_rc/RC}"
MY_PV="${MY_PV//_pre*}"

MY_P="${PN/sab/SAB}-${MY_PV}"

DESCRIPTION="Binary newsgrabber with web-interface"
HOMEPAGE="https://sabnzbd.org/"
SRC_URI="https://github.com/sabnzbd/sabnzbd/releases/download/${MY_PV}/${MY_P}-src.tar.gz"
S="${WORKDIR}/${MY_P}"

# Sabnzbd is GPL-2 but bundles software with the following licenses.
LICENSE="GPL-2 BSD LGPL-2 MIT BSD-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+7za +rar unzip test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPS="
	acct-user/sabnzbd
	acct-group/sabnzbd
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/cheetah3[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		>=dev-python/feedparser-6.0.10[${PYTHON_USEDEP}]
		>=dev-python/guessit-3.1.0[${PYTHON_USEDEP}]
		dev-python/notify2[${PYTHON_USEDEP}]
		dev-python/portend[${PYTHON_USEDEP}]
		dev-python/puremagic[${PYTHON_USEDEP}]
		<dev-python/sabyenc-6[${PYTHON_USEDEP}]
	')
"

DEPEND="${COMMON_DEPS}"

RDEPEND="
	${COMMON_DEPS}
	>=app-arch/par2cmdline-0.4
	net-misc/wget
	7za? ( app-arch/p7zip )
	rar? ( || ( app-arch/unrar app-arch/rar ) )
	unzip? ( >=app-arch/unzip-5.5.2 )
"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/flaky[${PYTHON_USEDEP}]
			>=dev-python/lxml-4.5.0[${PYTHON_USEDEP}]
			dev-python/pkginfo[${PYTHON_USEDEP}]
			dev-python/pyfakefs[${PYTHON_USEDEP}]
			dev-python/pytest-httpbin[${PYTHON_USEDEP}]
			dev-python/pytest-httpserver[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/selenium[${PYTHON_USEDEP}]
			dev-python/tavalidate[${PYTHON_USEDEP}]
			dev-python/tavern[${PYTHON_USEDEP}]
			dev-python/werkzeug[${PYTHON_USEDEP}]
			dev-python/xmltodict[${PYTHON_USEDEP}]
		')
		www-apps/chromedriver-bin
	)
"

pkg_setup() {
	MY_HOMEDIR="/var/lib/${PN}"
	python-single-r1_pkg_setup
}

src_test() {
	local EPYTEST_IGNORE=(
		# network sandbox
		tests/test_getipaddress.py
		tests/test_rss.py
		tests/test_urlgrabber.py
		tests/test_utils/test_happyeyeballs.py
		tests/test_utils/test_internetspeed.py
	)
	local EPYTEST_DESELECT=(
		# network sandbox
		'tests/test_consistency.py::TestWiki'
		# Just plain fails
		'tests/test_newsunpack.py::TestPar2Repair::test_basic'
		# Chromedriver tests don't want to behave in portage
		'tests/test_functional_config.py::TestBasicPages::test_base_pages'
		'tests/test_functional_config.py::TestBasicPages::test_base_submit_pages'
		'tests/test_functional_config.py::TestConfigLogin::test_login'
		'tests/test_functional_config.py::TestConfigCategories::test_page'
		'tests/test_functional_config.py::TestConfigRSS::test_rss_basic_flow'
		'tests/test_functional_config.py::TestConfigServers::test_add_and_remove_server'
		'tests/test_functional_downloads.py::TestDownloadFlow::test_download_basic_rar5'
		'tests/test_functional_downloads.py::TestDownloadFlow::test_download_zip'
		'tests/test_functional_downloads.py::TestDownloadFlow::test_download_7zip'
		'tests/test_functional_downloads.py::TestDownloadFlow::test_download_passworded'
		'tests/test_functional_downloads.py::TestDownloadFlow::test_download_fully_obfuscated'
		'tests/test_functional_downloads.py::TestDownloadFlow::test_download_unicode_rar'
		'tests/test_functional_misc.py::TestShowLogging::test_showlog'
		'tests/test_functional_misc.py::TestQueueRepair::test_queue_repair'
		'tests/test_functional_misc.py::TestDaemonizing::test_daemonizing'
	)
	epytest -s
}

# Sabnzbd is installed to /usr/share/ as upstream makes it clear they should not
# be in python's sitedir.  See: https://sabnzbd.org/wiki/advanced/unix-packaging

src_install() {
	local d

	for d in email icons interfaces locale po sabnzbd scripts tools; do
		insinto "/usr/share/${PN}/${d}"
		doins -r ${d}/*
	done

	exeinto "/usr/share/${PN}"
	doexe SABnzbd.py

	python_fix_shebang "${ED}/usr/share/${PN}"
	python_optimize "${ED}/usr/share/${PN}"

	newinitd "${FILESDIR}/${PN}-r1.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	diropts -o "${PN}" -g "${PN}"
	dodir "/etc/${PN}"
	keepdir "/var/log/${PN}"

	insinto "/etc/${PN}"
	insopts -m 0600 -o "${PN}" -g "${PN}"
	newins "${FILESDIR}"/${PN}-r1.ini ${PN}.ini

	dodoc ISSUES.txt README.mkd

	systemd_newunit "${FILESDIR}"/sabnzbd_at.service 'sabnzbd@.service'
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		einfo "Default directory: ${MY_HOMEDIR}"
		einfo
		einfo "To add a user to the sabnzbd group so it can edit SABnzbd+ files, run:"
		einfo
		einfo "    usermod -a -G sabnzbd <user>"
		einfo
		einfo "By default, SABnzbd will listen on TCP port 8080."
	else
		local v
		for v in ${REPLACING_VERSIONS}; do
			if ver_test "${v}" -lt 3; then
				ewarn
				ewarn "Due to changes in this release, the queue will be converted when ${PN}"
				ewarn "is started for the first time. Job order, settings and data will be"
				ewarn "preserved, but all jobs will be unpaused and URLs that did not finish"
				ewarn "fetching before the upgrade will be lost!"
				ewarn
				break
			fi
		done
	fi
}

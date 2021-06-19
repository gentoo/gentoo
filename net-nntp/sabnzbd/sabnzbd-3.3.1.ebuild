# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Require python-2 with sqlite USE flag
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 systemd

MY_PV="${PV/_rc/RC}"
MY_PV="${MY_PV//_pre*}"

MY_P="${PN/sab/SAB}-${MY_PV}"

DESCRIPTION="Binary newsgrabber with web-interface"
HOMEPAGE="https://sabnzbd.org/"
SRC_URI="https://github.com/sabnzbd/sabnzbd/releases/download/${MY_PV}/${MY_P}-src.tar.gz"

# Sabnzbd is GPL-2 but bundles software with the following licenses.
LICENSE="GPL-2 BSD LGPL-2 MIT BSD-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+7za +rar unzip"

# Sabnzbd is installed to /usr/share/ as upstream makes it clear they should not
# be in python's sitedir.  See: https://sabnzbd.org/wiki/advanced/unix-packaging

COMMON_DEPS="
	acct-user/sabnzbd
	acct-group/sabnzbd
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_MULTI_USEDEP}]
		dev-python/cheetah3[${PYTHON_MULTI_USEDEP}]
		dev-python/cherrypy[${PYTHON_MULTI_USEDEP}]
		dev-python/configobj[${PYTHON_MULTI_USEDEP}]
		dev-python/cryptography[${PYTHON_MULTI_USEDEP}]
		>=dev-python/feedparser-6[${PYTHON_MULTI_USEDEP}]
		dev-python/notify2[${PYTHON_MULTI_USEDEP}]
		dev-python/portend[${PYTHON_MULTI_USEDEP}]
		>=dev-python/sabyenc-4[${PYTHON_MULTI_USEDEP}]
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

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	MY_HOMEDIR="/var/lib/${PN}"
	python-single-r1_pkg_setup
}

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

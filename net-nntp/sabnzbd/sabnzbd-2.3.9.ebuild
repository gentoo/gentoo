# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# Require python-2 with sqlite USE flag
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1 user systemd

MY_P="${P/sab/SAB}"

DESCRIPTION="Binary newsgrabber with web-interface"
HOMEPAGE="https://sabnzbd.org/"
SRC_URI="https://github.com/sabnzbd/sabnzbd/releases/download/${PV}/${MY_P}-src.tar.gz"

# Sabnzbd is GPL-2 but bundles software with the following licenses.
LICENSE="GPL-2 BSD LGPL-2 MIT BSD-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+7za +rar unzip"

# Sabnzbd is installed to /usr/share/ as upstream makes it clear they should not
# be in python's sitedir.  See:  http://wiki.sabnzbd.org/unix-packaging

# TODO:  still bundled but not in portage:
# kronos, rsslib, ssmtplib, listquote, json-py, msgfmt, happyeyeballs
# pynewsleecher
#
# dev-python/rarfile is bundled as of 2.0.1 because sabnzbd is modifying it
# https://github.com/sabnzbd/sabnzbd/commit/de6d642b0dc6eaed63199a99d9a1a8b2e3d0018b
#
# Also note that cherrypy is still bundled.  It's near impossible to find
# out where the bundled and heavily patched version came from (pulled from
# cherrypy subversion, patched somewhere, then imported to sabnzbd and patched
# further.  Upstream is planning on making this easier with 0.8.0.
# https://github.com/sabnzbd/sabnzbd/issues/47

RDEPEND="
	${PYTHON_DEPS}
	>=app-arch/par2cmdline-0.4
	>=dev-python/cheetah-2.0.1[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/gntp[${PYTHON_USEDEP}]
	dev-python/pythonutils[${PYTHON_USEDEP}]
	>=dev-python/sabyenc-3.3.1[${PYTHON_USEDEP}]
	net-misc/wget
	7za? ( app-arch/p7zip )
	rar? ( || ( app-arch/unrar app-arch/rar ) )
	unzip? ( >=app-arch/unzip-5.5.2 )
"
DEPEND="${PYTHON_DEPS}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	HOMEDIR="/var/lib/${PN}"
	python-single-r1_pkg_setup

	# Create sabnzbd group
	enewgroup "${PN}"
	# Create sabnzbd user, put in sabnzbd group
	enewuser "${PN}" -1 -1 "${HOMEDIR}" "${PN}"
}

src_prepare() {
	eapply "${FILESDIR}"/patches

	# remove bundled modules
	rm -r sabnzbd/utils/{feedparser,configobj}.py || die
	rm -r gntp || die
	rm licenses/License-{feedparser,configobj,gntp}.txt || die

	eapply_user
}

src_install() {
	local d

	for d in cherrypy email icons interfaces locale po sabnzbd tools util; do
		insinto "/usr/share/${PN}/${d}"
		doins -r ${d}/*
	done

	exeinto "/usr/share/${PN}"
	doexe SABnzbd.py

	python_fix_shebang "${ED%/}/usr/share/${PN}"
	python_optimize "${ED%/}/usr/share/${PN}"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	diropts -o "${PN}" -g "${PN}"
	dodir "/etc/${PN}"
	dodir "/var/log/${PN}"

	insinto "/etc/${PN}"
	insopts -m 0600 -o "${PN}" -g "${PN}"
	doins "${FILESDIR}/${PN}.ini"

	dodoc {ABOUT,ISSUES,README}.txt licenses/*

	systemd_newunit "${FILESDIR}"/sabnzbd_at.service 'sabnzbd@.service'
}

pkg_postinst() {
	einfo "Default directory: ${HOMEDIR}"
	einfo
	einfo "To add a user to the sabnzbd group so it can edit SABnzbd+ files, run:"
	einfo
	einfo "    gpasswd -a <user> sabnzbd"
	einfo
	einfo "By default, SABnzbd+ will listen on TCP port 8080."
	einfo
	einfo "As Growl is not the default notification system on Gentoo, we disable it."

	local replacing
	local major
	local minor
	for replacing in ${REPLACING_VERSIONS}; do
		major=$(get_major_version ${replacing})
		minor=$(get_version_component_range 2 ${replacing})

		if [ "${major}" == "1" ]; then
			ewarn
			ewarn "Upgrading to ${PN}-2.x.y converts schedule items to a format"
			ewarn "that is not compatible with earlier ${PN}-1.x.y releases."
			ewarn
			break
		elif [ "${major}" == "2" ] && [ ${minor} -lt 2 ]; then
			ewarn
			ewarn "Due to changes in this release, the queue will be converted when ${PN}"
			ewarn "is started for the first time. Job order, settings and data will be"
			ewarn "preserved, but all jobs will be unpaused and URLs that did not finish"
			ewarn "fetching before the upgrade will be lost!"
			ewarn
			break
		fi

	done
}

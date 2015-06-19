# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/sabnzbd/sabnzbd-0.7.19.ebuild,v 1.1 2014/11/08 05:29:27 jsbronder Exp $

EAPI="4"

# Require python-2 with sqlite USE flag
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"

inherit eutils python user

MY_P="${P/sab/SAB}"

DESCRIPTION="Binary newsgrabber with web-interface"
HOMEPAGE="http://www.sabnzbd.org/"
SRC_URI="mirror://sourceforge/sabnzbdplus/${MY_P}-src.tar.gz"

# Sabnzbd is GPL-2 but bundles software with the following licenses.
LICENSE="GPL-2 BSD LGPL-2 MIT BSD-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+rar +ssl unzip +yenc"

# Sabnzbd is installed to /usr/share/ as upstream makes it clear they should not
# be in python's sitedir.  See:  http://wiki.sabnzbd.org/unix-packaging

# TODO:  still bundled but not in protage:
# kronos, rarfile, rsslib, ssmtplib, listquote, json-py, msgfmt
# pynewsleecher
#
# Also note that cherrypy is still bundled.  It's near impossible to find
# out where the bundled and heavily patched version came from (pulled from
# cherrypy subversion, patched somewhere, then imported to sabnzbd and patched
# further.  Upstream is planning on making this easier with 0.8.0.
# https://github.com/sabnzbd/sabnzbd/issues/47

RDEPEND="
	>=app-arch/par2cmdline-0.4
	>=dev-python/cheetah-2.0.1
	dev-python/configobj
	dev-python/feedparser
	dev-python/gntp
	dev-python/pythonutils
	net-misc/wget
	rar? ( || ( app-arch/unrar app-arch/rar ) )
	ssl? ( dev-python/pyopenssl )
	unzip? ( >=app-arch/unzip-5.5.2 )
	yenc? ( dev-python/yenc )
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	HOMEDIR="/var/lib/${PN}"
	python_set_active_version 2
	python_pkg_setup

	# Create sabnzbd group
	enewgroup ${PN}
	# Create sabnzbd user, put in sabnzbd group
	enewuser "${PN}" -1 -1 "${HOMEDIR}" "${PN}"
}

src_prepare() {
	epatch "${FILESDIR}"/use-system-configobj-and-feedparser.patch
	epatch "${FILESDIR}"/growler-support-gntp-1.0.patch
	epatch "${FILESDIR}"/par2cmdline.patch

	# remove bundled modules
	rm -r sabnzbd/utils/{feedparser,configobj}.py || die
	rm -r gntp || die
	rm licenses/License-{feedparser,configobj,gntp}.txt || die
}

src_install() {
	local d

	dodir /usr/share/${PN}/sabnzbd
	insinto /usr/share/${PN}/
	doins SABnzbd.py
	fperms +x /usr/share/${PN}/SABnzbd.py
	dobin "${FILESDIR}"/sabnzbd

	for d in cherrypy email icons interfaces locale po sabnzbd tools util; do
		insinto /usr/share/${PN}/${d}
		doins -r ${d}/*
	done

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	diropts -o ${PN} -g ${PN}
	dodir /etc/${PN}
	dodir /var/log/${PN}

	insinto "/etc/${PN}"
	insopts -m 0600 -o ${PN} -g ${PN}
	doins "${FILESDIR}/${PN}.ini"

	dodoc {ABOUT,CHANGELOG,ISSUES,README}.txt Sample-PostProc.sh licenses/*
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}

	einfo "Default directory: ${HOMEDIR}"
	einfo ""
	einfo "Run: gpasswd -a <user> sabnzbd"
	einfo "to add a user to the sabnzbd group so it can edit sabnzbd files"
	einfo ""
	einfo "By default sabnzbd will listen on 127.0.0.1:8080"
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="xml"

inherit distutils-r1 systemd

DESCRIPTION="Searchable online file/package database for Gentoo"
HOMEPAGE="http://www.portagefilelist.de https://github.com/portagefilelist/client"
SRC_URI="https://github.com/portagefilelist/client/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+network-cron"

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-python/requests[${PYTHON_USEDEP}]
	net-misc/curl
	sys-apps/portage[${PYTHON_USEDEP}]
	network-cron? ( sys-apps/util-linux[caps] )
"

S="${WORKDIR}/client-${PV}"

python_install_all() {
	if use network-cron ; then
		exeinto /etc/cron.weekly
		doexe cron/pfl
	fi

	systemd_dounit systemd/pfl.{service,timer}

	keepdir /var/lib/${PN}

	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/var/lib/${PN}/pfl.info" ]]; then
		touch "${EROOT}/var/lib/${PN}/pfl.info" || die
	fi
	chown -R portage:portage "${EROOT}/var/lib/${PN}" || die
	chmod 775 "${EROOT}/var/lib/${PN}" || die
}

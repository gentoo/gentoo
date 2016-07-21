# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 readme.gentoo systemd user

DESCRIPTION="BuildBot Slave Daemon"
HOMEPAGE="http://trac.buildbot.net/ https://code.google.com/p/buildbot/ https://pypi.python.org/pypi/buildbot-slave"

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-interix ~amd64-linux"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewuser buildbot

	DOC_CONTENTS="The \"buildbot\" user and the \"buildslave\" init script has been added
		to support starting buildslave through Gentoo's init system. To use this,
		set up your build slave following the documentation, make sure the
		resulting directories are owned by the \"buildbot\" user and point
		\"${ROOT}etc/conf.d/buildslave\" at the right location.  The scripts can
		run as a different user if desired. If you need to run more than one
		build slave, just copy the scripts."
}

src_install() {
	distutils-r1_src_install

	doman docs/buildslave.1

	newconfd "${FILESDIR}/buildslave.confd" buildslave
	newinitd "${FILESDIR}/buildslave.initd" buildslave
	systemd_dounit "${FILESDIR}/buildslave.service"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="https://github.com/buildbot/buildbot.git"

[[ ${PV} == *9999 ]] && inherit git-r3
inherit readme.gentoo user distutils-r1

DESCRIPTION="BuildBot Slave Daemon"
HOMEPAGE="http://trac.buildbot.net/ http://code.google.com/p/buildbot/ http://pypi.python.org/pypi/buildbot-slave"

MY_V="0.9.1"
MY_P="${PN}-${MY_V}"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE="test"

RDEPEND=">=dev-python/setuptools-21.2.1[${PYTHON_USEDEP}]
	|| ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-core-8.0.0[${PYTHON_USEDEP}]
	)
	dev-python/future[${PYTHON_USEDEP}]
	!<dev-util/buildbot-0.9.0_rc1"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"
[[ ${PV} == *9999 ]] && S=${S}/slave

pkg_setup() {
	enewuser buildbot

	DOC_CONTENTS="The \"buildbot\" user and the \"buildbot_worker\" init script has been added
		to support starting buildbot_worker through Gentoo's init system. To use this,
		set up your build worker following the documentation, make sure the
		resulting directories are owned by the \"buildbot\" user and point
		\"${ROOT}etc/conf.d/buildbot_worker\" at the right location.  The scripts can
		run as a different user if desired. If you need to run more than one
		build worker, just copy the scripts."
}

python_install_all() {
	distutils-r1_python_install_all

	doman docs/buildbot-worker.1

	newconfd "${FILESDIR}/buildbot_worker.confd" buildbot_worker
	newinitd "${FILESDIR}/buildbot_worker.initd" buildbot_worker
	systemd_dounit "${FILESDIR}/buildbot_worker.service"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

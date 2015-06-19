# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/buildbot-slave/buildbot-slave-9999.ebuild,v 1.3 2014/12/28 18:30:10 floppym Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
EGIT_REPO_URI="https://github.com/buildbot/buildbot.git"

[[ ${PV} = 9999 ]] && inherit git-2
inherit distutils-r1 readme.gentoo user

DESCRIPTION="BuildBot Slave Daemon"
HOMEPAGE="http://trac.buildbot.net/ http://code.google.com/p/buildbot/ http://pypi.python.org/pypi/buildbot-slave"

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"
[[ ${PV} = 9999 ]] || SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-interix ~amd64-linux"
fi
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

src_compile() {
	[[ ${PV} = 9999 ]] && cd slave/
	distutils-r1_src_compile
}

src_install() {
	[[ ${PV} = 9999 ]] && cd slave/
	distutils-r1_src_install

	doman docs/buildslave.1

	newconfd "${FILESDIR}/buildslave.confd" buildslave
	newinitd "${FILESDIR}/buildslave.initd" buildslave

	readme.gentoo_create_doc
}

pkg_postinst() {
	[[ ${PV} = 9999 ]] && cd slave/
	readme.gentoo_print_elog
}

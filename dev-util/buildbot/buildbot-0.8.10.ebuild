# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/buildbot/buildbot-0.8.10.ebuild,v 1.8 2015/07/29 07:04:48 vapier Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 readme.gentoo systemd user

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="BuildBot build automation system"
HOMEPAGE="http://buildbot.net/ http://pypi.python.org/pypi/buildbot"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc examples irc mail manhole test"

RDEPEND=">=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	<=dev-python/sqlalchemy-0.7.10-r999[${PYTHON_USEDEP}]
	~dev-python/sqlalchemy-migrate-0.7.2[${PYTHON_USEDEP}]
	irc? ( dev-python/twisted-words[${PYTHON_USEDEP}] )
	mail? ( dev-python/twisted-mail[${PYTHON_USEDEP}] )
	manhole? ( dev-python/twisted-conch[${PYTHON_USEDEP}] )"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/twisted-mail[${PYTHON_USEDEP}]
		dev-python/twisted-web[${PYTHON_USEDEP}]
		dev-python/twisted-words[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewuser buildbot

	DOC_CONTENTS="The \"buildbot\" user and the \"buildmaster\" init script has been added
		to support starting buildbot through Gentoo's init system. To use this,
		set up your build master following the documentation, make sure the
		resulting directories are owned by the \"buildbot\" user and point
		\"${EROOT}etc/conf.d/buildmaster\" at the right location. The scripts can
		run as a different user if desired. If you need to run more than one
		build master, just copy the scripts."
}

src_compile() {
	distutils-r1_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		#'man' target is currently broken
		emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils-r1_src_install

	doman docs/buildbot.1

	if use doc; then
		dohtml -r docs/_build/html/
		# TODO: install man pages
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r contrib docs/examples
	fi

	newconfd "${FILESDIR}/buildmaster.confd" buildmaster
	newinitd "${FILESDIR}/buildmaster.initd" buildmaster
	systemd_dounit "${FILESDIR}"/${PN}.service

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	elog
	elog "Upstream recommends the following when upgrading:"
	elog "Each time you install a new version of Buildbot, you should run the"
	elog "\"buildbot upgrade-master\" command on each of your pre-existing build masters."
	elog "This will add files and fix (or at least detect) incompatibilities between"
	elog "your old config and the new code."
}

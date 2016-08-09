# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="https://github.com/buildbot/${PN}.git"

[[ ${PV} == *9999 ]] && inherit git-r3
inherit readme.gentoo-r1 user systemd distutils-r1

MY_PV="${PV/_p/p}"
MY_V="0.9.0rc1"
MY_P="${PN}-${MY_V}"

DESCRIPTION="BuildBot build automation system"
HOMEPAGE="http://trac.buildbot.net/ https://github.com/buildbot/buildbot http://pypi.python.org/pypi/buildbot"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="crypt doc examples irc mail manhole test"

RDEPEND=">=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	|| (
		>=dev-python/twisted-web-14.0.1[${PYTHON_USEDEP}]
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
	)
	>=dev-python/sqlalchemy-0.8[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.9[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
	)
	irc? (
		|| ( >=dev-python/twisted-words-14.0.1[${PYTHON_USEDEP}]
			<dev-python/twisted-16.3.0[${PYTHON_USEDEP}]
		)
	)
	mail? (
		|| ( >=dev-python/twisted-mail-14.0.1[${PYTHON_USEDEP}]
			<dev-python/twisted-16.3.0[${PYTHON_USEDEP}]
		)
	)
	manhole? (
		|| ( >=dev-python/twisted-conch-14.0.1[${PYTHON_USEDEP}]
			<dev-python/twisted-16.3.0[${PYTHON_USEDEP}]
		)
	)
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
	>=dev-python/autobahn-0.10.2[${PYTHON_USEDEP}]
	<dev-python/autobahn-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/txaio-2.2.2[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-21.2.1[${PYTHON_USEDEP}]
	doc? ( >=dev-python/sphinx-1.4.3[${PYTHON_USEDEP}] )
	test? (
		>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		|| (
			(
				>=dev-python/twisted-mail-14.0.1[${PYTHON_USEDEP}]
				>=dev-python/twisted-web-14.0.1[${PYTHON_USEDEP}]
				>=dev-python/twisted-words-14.0.1[${PYTHON_USEDEP}]
			)
			<dev-python/twisted-16.3.0[${PYTHON_USEDEP}]
		)
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/ramlfications[${PYTHON_USEDEP}]
		dev-python/pyjade[${PYTHON_USEDEP}]
		dev-python/txgithub[${PYTHON_USEDEP}]
		dev-python/txrequests[${PYTHON_USEDEP}]
	)"

# still yet to be added deps
# doc? (     'sphinxcontrib-blockdiag',
#            'sphinxcontrib-spelling',
#            'pyenchant',
#            'docutils>=0.8',
#            'sphinx-jinja',)

S=${WORKDIR}/${MY_P}
[[ ${PV} == *9999 ]] && S=${S}/master

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

# docs generation is broken  might need a separate ebuild
#python_compile_all() {
	#if use doc; then
		#einfo "Generation of documentation"
		##'man' target is currently broken
		#emake -C docs html
	#fi
#}

python_install_all() {
	distutils-r1_python_install_all

	doman docs/buildbot.1

	#if use doc; then
	#	dohtml -r docs/_build/html/
	#	# TODO: install man pages
	#fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r contrib docs/examples
	fi

	newconfd "${FILESDIR}"/buildmaster.confd.9 buildmaster
	newinitd "${FILESDIR}"/buildmaster.initd.9 buildmaster
	systemd_dounit "${FILESDIR}/${PN}9".service

	# In case of multiple masters, it's possible to edit web files
	# so all master can share the changes. So protect them!
	# If something else need to be protected, please open a bug
	# on http://bugs.gentoo.org
	local cp
	add_config_protect() {
		cp+=" $(python_get_sitedir)/${PN}/status/web"
	}
	python_foreach_impl add_config_protect
	echo "CONFIG_PROTECT=\"${cp}\"" \
		> 85${PN} || die
	doenvd 85${PN}

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

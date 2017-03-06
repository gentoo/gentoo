# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="https://github.com/buildbot/${PN}.git"

inherit readme.gentoo-r1 user systemd distutils-r1

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="BuildBot build automation system"
HOMEPAGE="http://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.python.org/pypi/buildbot"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz
	http://dev.gentoo.org/~dolsen/distfiles/buildbot-0.9.4.docs.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="crypt doc examples irc mail manhole test"

RDEPEND=">=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	|| (
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-web-14.0.1[${PYTHON_USEDEP}]
	)
	>=dev-python/autobahn-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.8[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.9[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
	)
	irc? (
		dev-python/txrequests[${PYTHON_USEDEP}]
		|| ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
			>=dev-python/twisted-words-14.0.1[${PYTHON_USEDEP}]
		)
	)
	mail? (
		|| ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
			>=dev-python/twisted-mail-14.0.1[${PYTHON_USEDEP}]
		)
	)
	manhole? (
		|| ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
			>=dev-python/twisted-conch-14.0.1[${PYTHON_USEDEP}]
		)
	)
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
	>=dev-python/txaio-2.2.2[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-21.2.1[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.4.3[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-blockdiag[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-spelling[${PYTHON_USEDEP}]
		dev-python/pyenchant[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.8[${PYTHON_USEDEP}]
		dev-python/sphinx-jinja[${PYTHON_USEDEP}]
		dev-python/ramlfications[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		|| (
			>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
			(
				>=dev-python/twisted-mail-14.0.1[${PYTHON_USEDEP}]
				>=dev-python/twisted-web-14.0.1[${PYTHON_USEDEP}]
				>=dev-python/twisted-words-14.0.1[${PYTHON_USEDEP}]
			)
		)
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/ramlfications[${PYTHON_USEDEP}]
		dev-python/pyjade[${PYTHON_USEDEP}]
		dev-python/txgithub[${PYTHON_USEDEP}]
		dev-python/txrequests[${PYTHON_USEDEP}]
	)"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${MY_P}
	unpack buildbot-0.9.4.docs.tar.xz
}

pkg_setup() {
	enewuser buildbot

	DOC_CONTENTS="The \"buildbot\" user and the \"buildmaster\" init script has been added
		to support starting buildbot through Gentoo's init system. To use this,
		execute \"emerge --config =${CATEGORY}/${PF}\" to create a new instance.
		The scripts can	run as a different user if desired."
}

python_prepare_all() {
	if use doc; then
		epatch "${FILESDIR}/buildbot-0.9.4.docs.patch"
	fi
	distutils-r1_python_prepare_all
}

src_compile() {
	distutils-r1_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		EPYTHON="python2.7" emake html
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
	systemd_dounit "${FILESDIR}/buildmaster.target"
	systemd_newunit "${FILESDIR}/buildmaster_at.service" "buildmaster@.service"
	systemd_install_serviced "${FILESDIR}/buildmaster_at.service.conf" "buildmaster@.service"

	readme.gentoo_create_doc
}

python_test() {
	distutils_install_for_testing

	esetup.py test || die "Tests failed under ${EPYTHON}"
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		ewarn
		ewarn "Starting with buildbot-0.8.12-r2, more than one instance of buildmaster"
		ewarn "can be run simultaneously. Note that \"BASEDIR\" in the buildbot configuration file"
		ewarn "is now the common base directory for all instances. If you are migrating from an older"
		ewarn "version, make sure that you copy the current contents of \"BASEDIR\" to a subdirectory."
		ewarn "The name of the subdirectory corresponds to the name of the buildmaster instance."
		ewarn "In order to start the service running OpenRC-based systems need to link to the init file:"
		ewarn "    ln --symbolic --relative /etc/init.d/buildmaster /etc/init.d/buildmaster.myinstance"
		ewarn "    rc-update add buildmaster.myinstance default"
		ewarn "    /etc/init.d/buildmaster.myinstance start"
		ewarn "Systems using systemd can do the following:"
		ewarn "    systemctl enable buildmaster@myinstance.service"
		ewarn "    systemctl enable buildmaster.target"
		ewarn "    systemctl start buildmaster.target"
		elog
		elog "Upstream recommends the following when upgrading:"
		elog "Each time you install a new version of Buildbot, you should run the"
		elog "\"buildbot upgrade-master\" command on each of your pre-existing build masters."
		elog "This will add files and fix (or at least detect) incompatibilities between"
		elog "your old config and the new code."
	fi
	elog
	elog "In order to create a new instance of buildmaster, execute:"
	elog "    emerge --config =${CATEGORY}/${PF}"
}

pkg_config() {
	local buildmaster_path="/var/lib/buildmaster"
	einfo "This will prepare a new buildmaster instance in ${buildmaster_path}."
	einfo "Press Control-C to abort."

	einfo "Enter the name for the new instance: "
	read instance_name
	[[ -z "${instance_name}" ]] && die "Invalid instance name"

	local instance_path="${buildmaster_path}/${instance_name}"
	if [[ -e "${instance_path}" ]]; then
		eerror "The instance with the specified name already exists:"
		eerror "${instance_path}"
		die "Instance already exists"
	fi

	local buildbot="/usr/bin/buildbot"
	if [[ ! -d "${buildmaster_path}" ]]; then
		mkdir --parents "${buildmaster_path}" || die "Unable to create directory ${buildmaster_path}"
	fi
	"${buildbot}" create-master "${instance_path}" &>/dev/null || die "Creating instance failed"
	chown --recursive buildbot "${instance_path}" || die "Setting permissions for instance failed"
	mv "${instance_path}/master.cfg.sample" "${instance_path}/master.cfg" \
		|| die "Moving sample configuration failed"
	ln --symbolic --relative "/etc/init.d/buildmaster" "/etc/init.d/buildmaster.${instance_name}" \
		|| die "Unable to create link to init file"

	einfo "Successfully created a buildmaster instance at ${instance_path}."
	einfo "To change the default settings edit the master.cfg file in this directory."
}

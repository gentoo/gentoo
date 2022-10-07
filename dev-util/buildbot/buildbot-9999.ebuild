# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{8..10} )
EGIT_REPO_URI="https://github.com/buildbot/${PN}.git"
inherit readme.gentoo-r1 git-r3 systemd distutils-r1

DESCRIPTION="BuildBot build automation system"
HOMEPAGE="https://buildbot.net/
	https://github.com/buildbot/buildbot
	https://pypi.org/project/buildbot/"
S="${S}/master"

LICENSE="GPL-2"
SLOT="0"
IUSE="crypt docker examples irc test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-user/buildbot
	>=dev-python/twisted-18.7.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.1.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.3.0[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/alembic-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
	>=dev-python/txaio-2.2.2[${PYTHON_USEDEP}]
	>=dev-python/autobahn-0.16.0[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-util/buildbot-worker[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/pyopenssl-16.0.0[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		|| (
			>=dev-python/twisted-18.7.0[${PYTHON_USEDEP},ssl(-)]
			>=dev-python/twisted-18.7.0[${PYTHON_USEDEP},crypt(-)]
		)
		dev-python/idna[${PYTHON_USEDEP}]
	)
	irc? (
		dev-python/txrequests[${PYTHON_USEDEP}]
	)
	docker? (
		>=dev-python/docker-py-2.2.0[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/treq[${PYTHON_USEDEP}]
		dev-python/txrequests[${PYTHON_USEDEP}]
		dev-python/pypugjs[${PYTHON_USEDEP}]
		>=dev-python/boto3-1.12.48[${PYTHON_USEDEP}]
		dev-python/moto[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.6.0[${PYTHON_USEDEP}]
		dev-python/lz4[${PYTHON_USEDEP}]
		dev-python/ldap3[${PYTHON_USEDEP}]
		dev-util/buildbot-pkg[${PYTHON_USEDEP}]
		dev-util/buildbot-worker[${PYTHON_USEDEP}]
		dev-util/buildbot-www[${PYTHON_USEDEP}]
	)"

DOC_CONTENTS="The \"buildbot\" user and the \"buildmaster\" init script has been added
to support starting buildbot through Gentoo's init system. To use this,
execute \"emerge --config =${CATEGORY}/${PF}\" to create a new instance.
The scripts can	run as a different user if desired."

src_prepare() {
	# disable all warnings as errors
	sed -e "/warnings.filterwarnings('error')/d" -i buildbot/test/__init__.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" -m twisted.trial buildbot || die "Tests failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	doman docs/buildbot.1

	if use examples; then
		dodoc -r docs/examples
	fi

	newconfd "${FILESDIR}/buildmaster.confd" buildmaster
	newinitd "${FILESDIR}/buildmaster.initd" buildmaster
	systemd_dounit "${FILESDIR}/buildmaster.target"
	systemd_newunit "${FILESDIR}/buildmaster_at.service" "buildmaster@.service"
	systemd_install_serviced "${FILESDIR}/buildmaster_at.service.conf" "buildmaster@.service"

	readme.gentoo_create_doc
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
	local log_path="/var/log/buildmaster"

	einfo "This will prepare a new buildmaster instance in ${buildmaster_path}."
	einfo "Press Control-C to abort."

	einfo "Enter the name for the new instance: "
	read instance_name
	[[ -z "${instance_name}" ]] && die "Invalid instance name"

	local instance_path="${buildmaster_path}/${instance_name}"
	local instance_log_path="${log_path}/${instance_name}"

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
	chown --recursive buildbot:buildbot "${instance_path}" || die "Setting permissions for instance failed"
	mv "${instance_path}/master.cfg.sample" "${instance_path}/master.cfg" \
		|| die "Moving sample configuration failed"
	ln --symbolic --relative "/etc/init.d/buildmaster" "/etc/init.d/buildmaster.${instance_name}" \
		|| die "Unable to create link to init file"

	if [[ ! -d "${instance_log_path}" ]]; then
		mkdir --parents "${instance_log_path}" || die "Unable to create directory ${instance_log_path}"
		chown --recursive buildbot:buildbot "${instance_log_path}" \
			|| die "Setting permissions for instance failed"
	fi
	ln --symbolic --relative "${instance_log_path}/twistd.log" "${instance_path}/twistd.log" \
		|| die "Unable to create link to log file"

	einfo "Successfully created a buildmaster instance at ${instance_path}."
	einfo "To change the default settings edit the master.cfg file in this directory."
}

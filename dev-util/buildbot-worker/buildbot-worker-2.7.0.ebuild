# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )

EGIT_REPO_URI="https://github.com/buildbot/buildbot.git"

DISTUTILS_USE_SETUPTOOLS="rdepend"

[[ ${PV} == *9999 ]] && inherit git-r3
inherit readme.gentoo-r1 distutils-r1

DESCRIPTION="BuildBot Worker (slave) Daemon"
HOMEPAGE="https://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.org/project/buildbot-worker/"

MY_V="${PV/_p/.post}"
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
RESTRICT="!test? ( test )"

RDEPEND="
	acct-user/buildbot
	>=dev-python/twisted-17.9.0[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	!<dev-util/buildbot-1.0.0
"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/setuptools_trial[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_P}"
[[ ${PV} == *9999 ]] && S=${S}/worker

pkg_setup() {
	DOC_CONTENTS="The \"buildbot\" user and the \"buildbot_worker\" init script has been added
		to support starting buildbot_worker through Gentoo's init system. To use this,
		execute \"emerge --config =${CATEGORY}/${PF}\" to create a new instance.
		Set up your build worker following the documentation, make sure the
		resulting directories are owned by the \"buildbot\" user and point
		\"${ROOT}/etc/conf.d/buildbot_worker.myinstance\" at the right location.
		The scripts can	run as a different user if desired."
}

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all

	doman docs/buildbot-worker.1

	newconfd "${FILESDIR}/buildbot_worker.confd2" buildbot_worker
	newinitd "${FILESDIR}/buildbot_worker.initd2" buildbot_worker

	dodir /var/lib/buildbot_worker
	cp "${FILESDIR}/buildbot.tac.sample" "${D}/var/lib/buildbot_worker"|| die "Install failed!"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		ewarn
		ewarn "More than one instance of a buildbot_worker can be run simultaneously."
		ewarn " Note that \"BASEDIR\" in the buildbot_worker configuration file"
		ewarn "is now the common base directory for all instances. If you are migrating from an older"
		ewarn "version, make sure that you copy the current contents of \"BASEDIR\" to a subdirectory."
		ewarn "The name of the subdirectory corresponds to the name of the buildbot_worker instance."
		ewarn "In order to start the service running OpenRC-based systems need to link to the init file:"
		ewarn "    ln --symbolic --relative /etc/init.d/buildbot_worker /etc/init.d/buildbot_worker.myinstance"
		ewarn "    rc-update add buildbot_worker.myinstance default"
		ewarn "    /etc/init.d/buildbot_worker.myinstance start"
		ewarn "Systems using systemd can do the following:"
		ewarn "    systemctl enable buildbot_worker@myinstance.service"
		ewarn "    systemctl enable buildbot_worker.target"
		ewarn "    systemctl start buildbot_worker.target"
	fi
}

pkg_config() {
	local buildworker_path="/var/lib/buildbot_worker"
	local log_path="/var/log/buildbot_worker"

	einfo "This will prepare a new buildbot_worker instance in ${buildworker_path}."
	einfo "Press Control-C to abort."

	einfo "Enter the name for the new instance: "
	read instance_name
	[[ -z "${instance_name}" ]] && die "Invalid instance name"

	local instance_path="${buildworker_path}/${instance_name}"
	local instance_log_path="${log_path}/${instance_name}"

	if [[ -e "${instance_path}" ]]; then
		eerror "The instance with the specified name already exists:"
		eerror "${instance_path}"
		die "Instance already exists"
	fi

	if [[ ! -d "${instance_path}" ]]; then
		mkdir --parents "${instance_path}" || die "Unable to create directory ${buildworker_path}"
	fi
	chown --recursive buildbot "${instance_path}" || die "Setting permissions for instance failed"
	cp "${buildworker_path}/buildbot.tac.sample" "${instance_path}/buildbot.tac" \
		|| die "Moving sample configuration failed"
	ln --symbolic --relative "/etc/init.d/buildbot_worker" "/etc/init.d/buildbot_worker.${instance_name}" \
		|| die "Unable to create link to init file"

	if [[ ! -d "${instance_log_path}" ]]; then
		mkdir --parents "${instance_log_path}" || die "Unable to create directory ${instance_log_path}"
	fi
	ln --symbolic --relative "${instance_log_path}/twistd.log" "${instance_path}/twistd.log" \
		|| die "Unable to create link to log file"

	einfo "Successfully created a buildbot_worker instance at ${instance_path}."
	einfo "To change the default settings edit the buildbot.tac file in this directory."
}

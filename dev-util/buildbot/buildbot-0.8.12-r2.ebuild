# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 readme.gentoo systemd user

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="BuildBot build automation system"
HOMEPAGE="http://buildbot.net/ https://pypi.python.org/pypi/buildbot"
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
	>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
	test? (
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
		execute \"emerge --config =${CATEGORY}/${PF}\" to create a new instance.
		The scripts can	run as a different user if desired."
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

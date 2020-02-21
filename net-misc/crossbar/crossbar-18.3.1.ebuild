# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit  user systemd distutils-r1

MY_PV="${PV}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Crossbar.io - The Unified Application Router for the twisted framework"
HOMEPAGE="https://crossbar.io/ https://github.com/crossbario/crossbar https://pypi.org/project/crossbar/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/attrs-17.2.0[${PYTHON_USEDEP}]
	>=dev-python/autobahn-18.3.1[${PYTHON_USEDEP}]
	>=dev-python/bitstring-3.1.5[${PYTHON_USEDEP}]
	>=dev-python/cbor-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-6.7[${PYTHON_USEDEP}]
	>=dev-python/constantly-15.1.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.9.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/enum34-1.1.6[${PYTHON_USEDEP}]' python2_7)
	>=dev-python/hyper-h2-3.0.1[${PYTHON_USEDEP}]
	=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/incremental-17.5.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/ipaddress-1.0.18[${PYTHON_USEDEP}]' python2_7)
	>=dev-python/jinja-2.9.6[${PYTHON_USEDEP}]
	>=dev-python/lmdb-0.92[${PYTHON_USEDEP}]
	>=dev-python/mistune-0.7.4[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.19[${PYTHON_USEDEP}]
	>=dev-python/priority-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.2.2[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.2.3[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.0.9[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-17.1.0[${PYTHON_USEDEP}]
	>=dev-python/pytrie-0.3[${PYTHON_USEDEP}]
	>=dev-python/py-ubjson-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/pyqrcode-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
	>=dev-python/sdnotify-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/service_identity-17.0.0[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.1.10[${PYTHON_USEDEP}]
	>=dev-python/setuptools-36.0.1[${PYTHON_USEDEP}]
	>=dev-python/shutilwhich-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/treq-17.3.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-17.5.0[${PYTHON_USEDEP}]
	>=dev-python/txaio-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/u-msgpack-2.4.1[${PYTHON_USEDEP}]
	>=dev-python/watchdog-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.4.2[${PYTHON_USEDEP}]
	>=dev-python/txtorcon-0.19.3[${PYTHON_USEDEP}]
"
DEPEND="
	!dev-python/crossbar
	>=dev-python/setuptools-36.0.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-17.5.0[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
DOCS=(
	README.rst LICENSE-FOR-API LICENSE COPYRIGHT
)

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	# don't install the copyright, license... let dodoc do it
	sed -e "s/^    data_files=.*//" -i setup.py || die

	# remove these py2 deps from setuptools install_requires
	# it is not filtered out for >=py3.4 and results in test fails
	sed -e "s/^ipaddress.*//" -i requirements-min.txt || die
	sed -e "s/^enum34.*//" -i requirements-min.txt || die

	distutils-r1_python_prepare_all
}

pkg_setup() {
	enewuser crossbar
}

python_test() {
	pushd "${TEST_DIR}" > /dev/null || die
	/usr/bin/trial crossbar || die "Tests failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all

	keepdir /var/lib/crossbar
	insinto /var/lib/crossbar
	doins "${FILESDIR}/config.json.sample"

	newconfd "${FILESDIR}/confd" crossbar
	newinitd "${FILESDIR}/initd" crossbar
}

pkg_posinst() {
	einfo "For exapmle configurations and scripts"
	einfo "See: https://github.com/crossbario/crossbar-examples"

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		ewarn
		ewarn "Starting with crossbar-18.3.1 the tor service capability and dependency are now built-in"
		ewarn "Starting with net-misc/crossbar-17.6.1_p3-r1, more than one instance of crossbar"
		ewarn "can be run simultaneously. Note that \"BASEDIR\" in the crossbar conf.d/crossbar file"
		ewarn "is the common base directory for all instances. If you are migrating from an older"
		ewarn "version, make sure that you copy the current contents of \"BASEDIR\" to a subdirectory."
		ewarn "The name of the subdirectory corresponds to the name of the buildbot_worker instance."
		ewarn "In order to start the service running OpenRC-based systems need to link to the init file:"
		ewarn "    ln --symbolic --relative /etc/init.d/crossbar /etc/init.d/crossbar.myinstance"
		ewarn "    rc-update add crossbar.myinstance default"
		ewarn "    /etc/init.d/crossbar.myinstance start"
		ewarn "Systems using systemd can do the following:"
		ewarn "    systemctl enable crossbar@myinstance.service"
		ewarn "    systemctl enable crossbar.target"
		ewarn "    systemctl start crossbar.target"
	fi
}

pkg_config() {
	local crossbar_path="/var/lib/crossbar"
	local log_path="/var/log/crossbar"
	einfo "This will prepare a new crossbar instance in ${crossbar_path}."
	einfo "Press Control-C to abort."

	einfo "Enter the name for the new instance: "
	read instance_name
	[[ -z "${instance_name}" ]] && die "Invalid instance name"

	local instance_path="${crossbar_path}/${instance_name}"
	local instance_log_path="${log_path}/${instance_name}"

	if [[ -e "${instance_path}" ]]; then
		eerror "The instance with the specified name already exists:"
		eerror "${instance_path}"
		die "Instance already exists"
	fi

	if [[ ! -d "${instance_path}" ]]; then
		mkdir --parents "${instance_path}" || die "Unable to create directory ${crossbar_path}"
	fi
	chown --recursive crossbar "${instance_path}" || die "Setting permissions for instance failed"
	cp "${crossbar_path}/config.json.sample" "${instance_path}/config.json" \
		|| die "Moving sample configuration failed"
	ln --symbolic --relative "/etc/init.d/crossbar" "/etc/init.d/crossbar.${instance_name}" \
		|| die "Unable to create link to init file"

	if [[ ! -d "${instance_log_path}" ]]; then
		mkdir --parents "${instance_log_path}" || die "Unable to create directory ${instance_log_path}"
	fi
	ln --symbolic --relative "${instance_log_path}/node.log" "${instance_path}/node.log" \
		|| die "Unable to create link to log file"

	einfo "Successfully created a crossbar instance at ${instance_path}."
	einfo "To change the default settings edit the config.json file in this directory."
}

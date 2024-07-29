# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Disabled for now: bug #850628
#DISTUTILS_USE_PEP517=setuptools
# https://bugs.launchpad.net/cloud-init/+bug/1978328
PYTHON_COMPAT=( python3_10 python3_11 python3_12 )

inherit distutils-r1 udev

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.launchpad.net/cloud-init"
else
	SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Cloud instance initialisation magic"
HOMEPAGE="https://launchpad.net/cloud-init"

LICENSE="GPL-3"
SLOT="0"
IUSE="selinux"

CDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
"
BDEPEND="
	${CDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	net-analyzer/macchanger
	sys-apps/iproute2
	sys-fs/growpart
	virtual/logger
	selinux? ( sec-policy/selinux-cloudinit )
"

EPYTEST_IGNORE=(
	# Can't find file
	tests/unittests/config/test_apt_configure_sources_list_v1.py
	tests/unittests/config/test_apt_configure_sources_list_v3.py
)

distutils_enable_tests pytest

python_prepare_all() {
	# Fix location of documentation installation
	sed -i "s:USR + '/share/doc/cloud-init:USR + '/share/doc/${PF}:" setup.py || die

	if [[ ${PV} == *9999 ]] ; then
		sed -i 's/version=get_version(),/version=9999,/g' setup.py || die
	fi

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install --init-system=sysvinit_openrc,systemd --distro gentoo
}

python_install_all() {
	keepdir /etc/cloud

	distutils-r1_python_install_all

	# installs as non-executable
	chmod +x "${D}"/etc/init.d/* || die
}

pkg_prerm() {
	udev_reload
}

pkg_postinst() {
	udev_reload

	elog "cloud-init-local needs to be run in the boot runlevel because it"
	elog "modifies services in the default runlevel.  When a runlevel is started"
	elog "it is cached, so modifications that happen to the current runlevel"
	elog "while you are in it are not acted upon."
}

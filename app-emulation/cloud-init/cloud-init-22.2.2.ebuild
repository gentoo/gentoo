# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Disabled for now: bug #850628
# https://bugs.launchpad.net/cloud-init/+bug/1978328
#DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 udev

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.launchpad.net/cloud-init"
else
	SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"
	KEYWORDS="amd64 arm64 ppc64 x86"
fi

DESCRIPTION="Cloud instance initialisation magic"
HOMEPAGE="https://launchpad.net/cloud-init"

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

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
		>=dev-python/httpretty-0.7.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
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
"

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

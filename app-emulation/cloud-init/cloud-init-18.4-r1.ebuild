# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1

DESCRIPTION="Cloud instance initialisation magic"
HOMEPAGE="https://launchpad.net/cloud-init"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		>=dev-python/httpretty-0.7.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/contextlib2[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	net-analyzer/macchanger
	sys-apps/iproute2
	sys-fs/growpart
	virtual/logger
"

PATCHES=(
	# Fix Gentoo support
	# https://code.launchpad.net/~gilles-dartiguelongue/cloud-init/+git/cloud-init/+merge/358777
	"${FILESDIR}"/${P}-fix-packages-module.patch
	"${FILESDIR}"/${P}-gentoo-support-upstream-templates.patch
	"${FILESDIR}"/${PV}-fix-filename-for-storing-locale.patch
	"${FILESDIR}"/${PV}-fix-update_package_sources-function.patch
	"${FILESDIR}"/${PV}-add-support-for-package_upgrade.patch
)

src_prepare() {
	# Fix location of documentation installation
	sed -i "s:USR + '/share/doc/cloud-init:USR + '/share/doc/${PF}:" setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	# Do not use Makefile target as it does not setup environment correclty
	esetup.py nosetests -v --where cloudinit --where tests/unittests || die
}

python_install() {
	distutils-r1_python_install --init-system=sysvinit_openrc,systemd --distro gentoo
}

python_install_all() {
	keepdir /etc/cloud

	distutils-r1_python_install_all

	# installs as non-executable
	chmod +x "${D}"/etc/init.d/*
}

pkg_postinst() {
	elog "cloud-init-local needs to be run in the boot runlevel because it"
	elog "modifies services in the default runlevel.  When a runlevel is started"
	elog "it is cached, so modifications that happen to the current runlevel"
	elog "while you are in it are not acted upon."
}

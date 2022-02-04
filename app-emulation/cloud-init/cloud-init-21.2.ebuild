# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://git.launchpad.net/cloud-init"
else
	SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
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
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
		${CDEPEND}
	test? (
		>=dev-python/httpretty-0.7.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
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
	"${FILESDIR}/${PN}-18.4-fix-packages-module.patch"
	"${FILESDIR}/${PN}-21.2-gentoo-support-upstream-templates.patch"
	"${FILESDIR}"/18.4-fix-filename-for-storing-locale.patch
	"${FILESDIR}"/18.4-fix-update_package_sources-function.patch
	"${FILESDIR}"/18.4-add-support-for-package_upgrade.patch
)

python_prepare_all() {
	# Fix location of documentation installation
	sed -i "s:USR + '/share/doc/cloud-init:USR + '/share/doc/${PF}:" setup.py || die
	sed -i 's/version=get_version(),/version=9999,/g' setup.py || die
	distutils-r1_python_prepare_all
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

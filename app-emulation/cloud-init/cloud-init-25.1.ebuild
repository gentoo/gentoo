# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit edo python-single-r1 udev

DESCRIPTION="Cloud instance initialisation magic"
HOMEPAGE="https://launchpad.net/cloud-init"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.launchpad.net/cloud-init"
else
	SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="selinux test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	$(python_gen_cond_dep '
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/oauthlib[${PYTHON_USEDEP}]
		dev-python/pyserial[${PYTHON_USEDEP}]
		>=dev-python/configobj-5.0.2[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/jsonpatch[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/netifaces[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/passlib[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/responses[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="
	${COMMON_DEPEND}
	${PYTHON_DEPS}
	net-analyzer/macchanger
	net-analyzer/openbsd-netcat
	sys-apps/iproute2
	sys-fs/growpart
	virtual/logger
	selinux? ( sec-policy/selinux-cloudinit )
"

EPYTEST_IGNORE=(
	# Can't find file
	tests/unittests/config/test_apt_configure_sources_list_v1.py
	tests/unittests/config/test_apt_configure_sources_list_v3.py
	# PORTAGE_TMPDIR too long for unix sockets
	tests/unittests/test_all_stages.py
	# TODO
	tests/unittests/config/test_schema.py
)

src_prepare() {
	default

	# Fix location of documentation installation
	sed -i "s:USR + \"/share/doc/cloud-init:USR + \"/share/doc/${PF}:" setup.py || die

	if [[ ${PV} == *9999 ]] ; then
		sed -i 's/version=get_version(),/version=9999,/g' setup.py || die
	fi
}

src_compile() {
	edo ${EPYTHON} setup.py build
}

src_test() {
	epytest
}

src_install() {
	edo ${EPYTHON} setup.py install \
		--prefix="${EPREFIX}/usr" \
		--root="${D}" \
		--init-system=sysvinit_openrc,systemd \
		--distro gentoo
	python_optimize

	keepdir /etc/cloud

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

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils autotools linux-info python-single-r1
COMMIT="c9a4f15b8c8f2349601d3073cc95e30d3b91af13"
DESCRIPTION="Unix Guest Agent for OpenStack"
HOMEPAGE="https://wiki.openstack.org/wiki/GuestAgent"
SRC_URI="https://github.com/rackerlabs/${PN}/archive/${COMMIT}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror strip"
DEPEND="
	app-emulation/xe-guest-utilities[-xenstore]
	dev-util/patchelf
	dev-python/pycrypto[${PYTHON_USEDEP}]
	test? ( dev-python/mox[${PYTHON_USEDEP}] )
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )
	${PYTHON_DEPS}
"
RDEPEND="
	app-emulation/xe-guest-utilities
	dev-python/pyxenstore[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	${PYTHON_DEPS}
"
S=${WORKDIR}/${PN}-${COMMIT}

# Required for Emergency Console
CONFIG_CHECK="~KEYBOARD_ATKBD"

pkg_setup()
{
	python-single-r1_pkg_setup
}
src_prepare()
{
	# Note: https://github.com/rackerlabs/openstack-guest-agents-unix/issues/52
	ebegin 'patching tests/test_injectfile.py'
	sed -e '97,127 d' -i tests/test_injectfile.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	eapply_user
	eautoreconf
}

src_install()
{
	emake DESTDIR="${D}" install || die
	doinitd scripts/gentoo/nova-agent
}

pkg_postinst()
{
	if [ "$(rc-config list default | grep nova-agent)" = "" ] ; then
		elog "To start nova-agent automatically by default"
		elog "you should add it to the default runlevel :"
		elog "\`rc-update add nova-agent default\`"
		elog
	fi
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1 vcs-snapshot

DESCRIPTION="Openstack Unix Guest Agent"
HOMEPAGE="http://github.com/rackerlabs/openstack-guest-agents-unix"
SRC_URI="https://github.com/rackerlabs/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/pyxenstore[${PYTHON_USEDEP}]
	dev-util/patchelf
	${PYTHON_DEPS}
"
DEPEND="
	${CDEPEND}
	test? (
		dev-python/mox[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/4453b4773688eef6c60736d9cf07100716308a5e.patch \
		"${FILESDIR}"/0513f013625b6a652d7dcb663eb396b9b5bb924e.patch

	# Note: https://github.com/rackerlabs/openstack-guest-agents-unix/issues/52
	ebegin 'patching tests/test_injectfile.py'
	sed \
		-e '97,127 d' \
		-i tests/test_injectfile.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install

	doinitd scripts/gentoo/nova-agent
}

pkg_postinst() {
	elog "If you would like to utilize openstack-guest-agents-unix, add 'nova-agent' to"
	elog "your 'default' runlevel:"
	elog "  rc-update add nova-agent default"
}

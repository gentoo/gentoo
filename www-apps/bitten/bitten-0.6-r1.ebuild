# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_PN=Bitten
MY_P=${MY_PN}-${PV}

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils user

DESCRIPTION="Continuous integration plugin for Trac"
HOMEPAGE="http://bitten.edgewall.org/"
SRC_URI="http://ftp.edgewall.com/pub/${PN}/${MY_P}.tar.gz"

LICENSE="BSD Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="server test"

CDEPEND="dev-python/setuptools"
DEPEND="${CDEPEND}
	test? ( dev-python/figleaf )"
RDEPEND="${CDEPEND}
	server? ( www-apps/trac )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_pkg_setup
	DISTUTILS_GLOBAL_OPTIONS=("2.* $(use_with server master)")
	enewgroup tracd
	enewuser ${PN} -1 -1 /var/tmp/${PN} tracd
}

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_postinst() {
	touch "${ROOT}"/var/log/${PN}.log
	chown -f ${PN}:tracd "${ROOT}"/var/log/${PN}.log
}

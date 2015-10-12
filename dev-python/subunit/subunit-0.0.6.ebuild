# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit python

DESCRIPTION="A streaming protocol for test results"
HOMEPAGE="https://launchpad.net/subunit https://pypi.python.org/pypi/python-subunit"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-python/testtools-0.9.4"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-libs/check
	dev-util/cppunit
	virtual/pkgconfig"
RESTRICT_PYTHON_ABIS="3.*"

pkg_postinst() {
	python_mod_optimize subunit
}

pkg_postrm() {
	python_mod_cleanup subunit
}

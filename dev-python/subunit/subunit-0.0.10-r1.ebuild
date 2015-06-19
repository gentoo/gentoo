# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/subunit/subunit-0.0.10-r1.ebuild,v 1.8 2015/04/08 08:04:59 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit autotools-utils python-single-r1

DESCRIPTION="A streaming protocol for test results"
HOMEPAGE="https://launchpad.net/subunit http://pypi.python.org/pypi/python-subunit"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-python/testtools-0.9.23[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-libs/check
	dev-util/cppunit
	>=sys-devel/automake-1.12
	virtual/pkgconfig"

src_prepare() {
	# update py-compile to handle py3 properly
	# XXX: handle it in the eclass?
	cp "$(automake --print-libdir || die)"/py-compile . || die
	epatch "${FILESDIR}"/shell-tests.patch

	autotools-utils_src_prepare
}

src_test() {
	if ! PYTHONPATH="${S}"/python/ "${PYTHON}" runtests.py; then
		die "Tests failed under ${EPYTHON}"
	fi
}

src_install() {
	autotools-utils_src_install

	python_fix_shebang "${D}"/usr/bin
}

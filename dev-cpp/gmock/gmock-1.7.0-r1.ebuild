# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

PYTHON_COMPAT=( python2_7 )

inherit libtool multilib-minimal python-any-r1

DESCRIPTION="Google's C++ mocking framework"
HOMEPAGE="http://code.google.com/p/googlemock/"
SRC_URI="http://googlemock.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static-libs test"

RDEPEND="=dev-cpp/gtest-${PV}*[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
	app-arch/unzip"

pkg_setup() {
	# Stub to disable python_setup running when USE=-test.
	# We'll handle it down in src_test ourselves.
	:
}

src_unpack() {
	default
	# make sure we always use the system one
	rm -r "${S}"/gtest/{Makefile,configure}* || die
}

src_prepare() {
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.in
	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf $(use_enable static-libs static)
}

multilib_src_test() {
	python_setup
	emake check
}

multilib_src_install() {
	default
	dobin scripts/gmock-config
}

multilib_src_install_all() {
	use static-libs || find "${ED}" -name '*.la' -delete
}

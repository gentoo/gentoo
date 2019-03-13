# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="modern style C++ library that provides a simple and easy interface to libxml2"
HOMEPAGE="http://vslavik.github.io/xmlwrapp/"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/6.4" # subslot = SONAME(libxmlwrapp.so) + SONAME(libxsltwrapp.so)
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="
	dev-libs/boost:=[${MULTILIB_USEDEP}]
	dev-libs/libxml2:=[${MULTILIB_USEDEP}]
	dev-libs/libxslt:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/boost-m4"

src_prepare() {
	default

	# Unbundle boost.m4, rely on
	# sys-devel/boost-m4 instead
	rm admin/boost.m4 || die

	sed -i -e '/XMLWRAPP_VISIBILITY/d' configure.ac || die

	eautoreconf
}

multilib_src_configure() {
	# bug 619804
	local -x CXXFLAGS="${CXXFLAGS}"
	append-cxxflags -std=c++14

	ECONF_SOURCE=${S} econf \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs

	# package installs .pc files
	find "${D}" -name '*.la' -delete || die
}

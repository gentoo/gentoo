# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/beecrypt/beecrypt-4.2.1.ebuild,v 1.18 2012/06/07 16:43:17 kensington Exp $

EAPI=4
PYTHON_DEPEND="python? 2"

inherit eutils multilib autotools java-pkg-opt-2 python

DESCRIPTION="general-purpose cryptography library"
HOMEPAGE="http://sourceforge.net/projects/beecrypt/"
SRC_URI="mirror://sourceforge/beecrypt/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="java cxx python static-libs threads doc"

COMMONDEPEND="!<app-arch/rpm-4.2.1
	cxx? ( >=dev-libs/icu-2.8 )"

DEPEND="${COMMONDEPEND}
	java? ( >=virtual/jdk-1.4 )
	doc? ( app-doc/doxygen
		virtual/latex-base
		dev-texlive/texlive-fontsextra
	)"
RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.4 )"

DOCS="BUGS README BENCHMARKS NEWS"

REQUIRED_USE="cxx? ( threads )"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
		java-pkg-opt-2_pkg_setup
	fi
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	use python && python_convert_shebangs -r 2 .

	epatch "${FILESDIR}"/${P}-build-system.patch
	epatch "${FILESDIR}"/${P}-gcc-4.7.patch
	eautoreconf
}

src_configure() {
	# cpluscplus needs threads support
	econf \
		--disable-expert-mode \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(use_with python python "${EPREFIX}"/usr/bin/python2) \
		$(use_with cxx cplusplus) \
		$(use_with java)
}

src_compile() {
	default

	if use doc; then
		cd include/beecrypt
		doxygen || die "doxygen failed"
	fi
}

src_test() {
	export BEECRYPT_CONF_FILE="${T}/beecrypt-test.conf"
	echo "provider.1=${S}/c++/provider/.libs/base.so" > "${BEECRYPT_CONF_FILE}"
	emake check
	emake bench
}

src_install() {
	default
	rm -f "${ED}"/usr/$(get_libdir)/python*/site-packages/_bc.*a

	use static-libs || find "${ED}" -name '*.la' -exec rm -f {} +

	use doc && dohtml -r docs/html/.
}

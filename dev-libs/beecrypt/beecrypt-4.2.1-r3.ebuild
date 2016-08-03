# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib autotools java-pkg-opt-2 python-single-r1

DESCRIPTION="general-purpose cryptography library"
HOMEPAGE="https://sourceforge.net/projects/beecrypt/"
SRC_URI="mirror://sourceforge/beecrypt/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos"
IUSE="+threads java cxx python static-libs doc"

COMMONDEPEND="!<app-arch/rpm-4.2.1
	cxx? ( >=dev-libs/icu-2.8:= )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${COMMONDEPEND}
	java? ( >=virtual/jdk-1.4 )
	doc? ( app-doc/doxygen
		virtual/latex-base
		dev-texlive/texlive-fontsextra
	)"
RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.4 )"

DOCS="BUGS README BENCHMARKS NEWS"

REQUIRED_USE="cxx? ( threads )
	python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare

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
		$(use_with python python "${PYTHON}") \
		$(use_with cxx cplusplus) \
		$(use_with java)
}

src_compile() {
	default

	if use doc; then
		cd include/beecrypt || die
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
	use python && rm -f "${D%/}$(python_get_sitedir)"/_bc.*a

	use static-libs || find "${ED}" -name '*.la' -delete

	use doc && dohtml -r docs/html/.
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit autotools eutils gnome2 java-pkg-opt-2 python-any-r1

DESCRIPTION="A Syntactic English parser"
HOMEPAGE="http://www.abisource.com/projects/link-grammar/ http://www.link.cs.cmu.edu/link/"
SRC_URI="http://www.abisource.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

IUSE="aspell +hunspell java python static-libs threads"

RDEPEND="
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
	java? (
		>=virtual/jdk-1.6:*
		dev-java/ant-core )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-lang/swig:0
"

pkg_setup() {
	if use aspell && use hunspell; then
		ewarn "You have enabled 'aspell' and 'hunspell' support, but both cannot coexist,"
		ewarn "only hunspell will be built. Press Ctrl+C and set only 'aspell' USE flag if"
		ewarn "you want aspell support."
	fi
	use java && java-pkg-opt-2_pkg_setup
	use python && python-any-r1_pkg_setup
}

src_prepare() {
	use java && java-pkg-opt-2_src_prepare
	AT_M4DIR="ac-helpers/" eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-perl-bindings \
		--enable-shared \
		$(use_enable aspell) \
		$(use_enable hunspell) \
		$(usex hunspell --with-hunspell-dictdir=/usr/share/myspell) \
		$(use_enable java java-bindings) \
		$(use_enable python python-bindings) \
		$(use_enable static-libs static) \
		$(use_enable threads pthreads)
}

pkg_preinst() {
	use java && java-pkg-opt-2_pkg_preinst
	gnome2_pkg_preinst
}

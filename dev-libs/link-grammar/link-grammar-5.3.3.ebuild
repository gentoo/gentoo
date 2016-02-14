# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils gnome2 java-pkg-opt-2 python-any-r1

DESCRIPTION="A Syntactic English parser"
HOMEPAGE="http://www.abisource.com/projects/link-grammar/ http://www.link.cs.cmu.edu/link/"
SRC_URI="https://github.com/opencog/${PN}/archive/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="aspell +hunspell java python static-libs threads"

DEPEND="
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
	java? ( virtual/jdk:= dev-java/ant-core )
	${PYTHON_DEPS}"

RDEPEND="${DEPEND}"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	if use aspell && use hunspell; then
		ewarn "You have enabled 'aspell' and 'hunspell' support, but both cannot coexist,"
		ewarn "only aspell will be build. Press Ctrl+C and set only 'hunspell' USE flag if"
		ewarn "you want hunspell support."
	fi
}

src_unpack() {
	unpack ${A}
	S=${WORKDIR}/${PN}-${P}
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	./autogen.sh || die
}

src_configure() {
	local myconf

	use hunspell && myconf="${myconf} --with-hunspell-dictdir=/usr/share/myspell"
	gnome2_src_configure \
		--enable-shared \
		$(use_enable aspell) \
		$(use_enable hunspell) \
		$(use_enable java java-bindings) \
		$(use_enable python python-bindings) \
		$(use_enable static-libs static) \
		$(use_enable threads pthreads) \
		${myconf}
}

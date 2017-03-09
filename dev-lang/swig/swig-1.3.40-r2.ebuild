# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"
DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="http://www.swig.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD BSD-2"
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="ccache doc"
RESTRICT="test"
DEPEND=""
RDEPEND=""

src_prepare () {
	rm -v aclocal.m4 || die "Unable to remove aclocal.m4"
	./autogen.sh || die "Autogen script failed"

	# Use swig1.3 as binary instead of swig
	sed -i -e 's:TARGET_NOEXE= swig:TARGET_NOEXE= swig1.3:' Makefile.in
	sed -i -e 's:/swig@EXEEXT@:/swig1.3@EXEEXT@:g' Source/Makefile.{am,in}
	sed -i -e "s:PACKAGE_NAME='ccache-swig':PACKAGE_NAME='ccache-swig1.3':" CCache/configure
	mv CCache/ccache-swig.1 CCache/ccache-swig1.3.1
}

src_configure () {
	econf \
		$(use_enable ccache)
}

src_install() {
	emake DESTDIR="${D}" install || die "target install failed"
	dodoc ANNOUNCE CHANGES CHANGES.current FUTURE NEW README TODO || die "dodoc failed"
	if use doc; then
		dohtml -r Doc/{Devel,Manual} || die "Failed to install html documentation"
	fi
}

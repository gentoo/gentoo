# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools-multilib

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/21" # 21 from SONAME
KEYWORDS="amd64 -arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples static-libs"

RDEPEND=">=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	>=media-libs/ilmbase-${PV}:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	# Fix path for testsuite
	sed -i -e "s:/var/tmp/:${T}:" IlmImfTest/tmpDir.h || die
	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable examples imfexamples)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install \
		docdir="${EPREFIX}"/usr/share/doc/${PF}/pdf \
		examplesdir="${EPREFIX}"/usr/share/doc/${PF}/examples

	docompress -x /usr/share/doc/${PF}/examples

	if ! use examples; then
		rm -rf "${ED}"/usr/share/doc/${PF}/examples
	fi
}

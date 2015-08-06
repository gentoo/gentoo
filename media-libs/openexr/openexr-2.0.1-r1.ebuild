# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openexr/openexr-2.0.1-r1.ebuild,v 1.3 2015/08/06 16:45:43 klausman Exp $

EAPI=5
inherit autotools-multilib

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2.0.1" # 2.0.1 for the namespace off -> on switch, caused library renaming
KEYWORDS="~amd64 -arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
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
		docdir=/usr/share/doc/${PF}/pdf \
		examplesdir=/usr/share/doc/${PF}/examples

	docompress -x /usr/share/doc/${PF}/examples

	if ! use examples; then
		rm -rf "${ED}"/usr/share/doc/${PF}/examples
	fi
}

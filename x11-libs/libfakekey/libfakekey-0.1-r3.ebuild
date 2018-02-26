# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Helper library for the x11-misc/matchbox-keyboard package"
HOMEPAGE="https://www.yoctoproject.org/tools-resources/projects/matchbox"
SRC_URI="http://downloads.yoctoproject.org/releases/matchbox/${PN}/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="debug doc"

RDEPEND="x11-libs/libXtst"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	# Allow configure to use libtool-2
	"${FILESDIR}/${P}-ac.patch"
)

src_prepare() {
	default

	# Fix underlinking bug #367595
	sed -i -e 's/^fakekey_test_LDADD=/fakekey_test_LDADD=-lX11 /' \
		tests/Makefile.am || die 'Cannot sed Makefile.am'
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	# --with/without-x is ignored by configure script and X is used.
	econf --with-x \
		$(use_enable debug) \
		$(use_enable doc doxygen-docs)
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}

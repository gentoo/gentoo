# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils  eutils toolchain-funcs

DESCRIPTION="Tcl/Tk Theming library"
HOMEPAGE="http://www.xmission.com/~georgeps/Tk_Theme/other/"
SRC_URI="mirror://gentoo/${PN}.tgz -> ${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="debug examples static-libs threads"

DEPEND="
	dev-lang/tk
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${PV}-Makefile.in.diff
	"${FILESDIR}"/${PV}-configure.diff
	"${FILESDIR}"/${PV}-cflags.patch
	)

src_configure() {
	tc-export CC
	local myeconfargs=(
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		--with-tk="${EPREFIX}/usr/$(get_libdir)"
		--with-x
		$(use_with debug symbols)
		$(use_enable threads)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	insinto /usr/share/${PN}
	use examples && doins -r demo
}

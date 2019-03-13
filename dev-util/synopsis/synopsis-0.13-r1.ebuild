# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 multilib toolchain-funcs

DESCRIPTION="General source code documentation tool"
HOMEPAGE="http://synopsis.fresco.org/index.html"
SRC_URI="http://synopsis.fresco.org/download/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND="dev-libs/boehm-gc[cxx]"
RDEPEND="${COMMON_DEPEND}
	media-gfx/graphviz"
DEPEND="${COMMON_DEPEND}
	${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12-gcc45.patch
	"${FILESDIR}"/${PN}-0.13-bdwgc-8.patch
)

pkg_setup() {
	tc-export CC CXX
}

python_prepare() {
	rm -r src/Synopsis/gc || die "failed to remove bundled lib"

	# the distutils script passes its options to a number of
	# autoconf scripts, to not all of which these options are
	# relevant. adding this option disables these useless warnings.
	sed -e "/self.announce(command)/i\        command += ' --disable-option-checking'" \
		-i Synopsis/dist/command/config.py || die
}

python_configure() {
	local mydistutilsargs=(
		config
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--with-gc-prefix="${EPREFIX}"/usr
	)
	esetup.py
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="\"M\"peg \"A\"udio \"D\"ecoder library"
HOMEPAGE="http://mad.sourceforge.net"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="debug static-libs"

DEPEND=""
RDEPEND=""

DOCS=( CHANGES CREDITS README TODO VERSION )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/mad.h
)

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-cflags-O2.patch
	"${FILESDIR}"/${P}-gcc44-mips-h-constraint-removal.patch
	"${FILESDIR}"/${P}-CVE-2017-8372_CVE-2017-8373_CVE-2017-8374.patch
)

src_prepare() {
	default

	# bug 467002
	sed -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' -i configure.ac || die

	eautoreconf
}

multilib_src_configure() {
	# --enable-speed		 optimize for speed over accuracy
	# --enable-accuracy		 optimize for accuracy over speed
	# --enable-experimental	 enable code using the EXPERIMENTAL
	#						 preprocessor define
	local myconf=(
		--enable-accuracy
		$(use_enable debug debugging)
		$(use_enable static-libs static)
	)

	# Fix for b0rked sound on sparc64 (maybe also sparc32?)
	# default/approx is also possible, uses less cpu but sounds worse
	use sparc && myconf+=( --enable-fpm=64bit )

	[[ $(tc-arch) == "amd64" ]] && myconf+=( --enable-fpm=64bit )
	[[ $(tc-arch) == "x86" ]] && myconf+=( --enable-fpm=intel )
	[[ $(tc-arch) == "ppc" ]] && myconf+=( --enable-fpm=default )
	[[ $(tc-arch) == "ppc64" ]] && myconf+=( --enable-fpm=64bit )

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# This file must be updated with each version update
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}"/mad.pc

	# Use correct libdir in pkgconfig file
	sed -e "s:^libdir.*:libdir=${EPREFIX}/usr/$(get_libdir):" \
		-i "${ED}"/usr/$(get_libdir)/pkgconfig/mad.pc
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="reimplement libdjb - excellent libraries from Dan Bernstein"
SRC_URI="https://www.fefe.de/${PN}/${P}.tar.xz"
HOMEPAGE="https://www.fefe.de/libowfat/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE="diet"

RDEPEND="diet? ( >=dev-libs/dietlibc-0.33_pre20090721 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc10.patch
	"${FILESDIR}"/${P}-ar.patch
)

pkg_setup() {
	# Required for mult/umult64.c to be usable
	append-flags -fomit-frame-pointer
}

src_prepare() {
	default

	# do not define "__pure__", this the gcc builtin (bug #806505)
	sed 's#__pure__;#__attribute__((__pure__));#' -i fmt.h scan.h byte.h stralloc.h str.h critbit.h || die
	sed 's#__pure__$#__attrib__pure__#' -i  fmt.h scan.h byte.h stralloc.h str.h critbit.h || die
	# remove unneeded definition of __deprecated__
	sed '/^#define __deprecated__$/d' -i scan/scan_iso8601.c scan/scan_httpdate.c || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB) \
		CFLAGS="-I. ${CFLAGS}" \
		DIET="${EPREFIX}/usr/bin/diet -Os" \
		prefix="${EPREFIX}/usr" \
		INCLUDEDIR="${EPREFIX}/usr/include" \
		$( use diet || echo 'DIET=' )
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		MAN3DIR="${EPREFIX}/usr/share/man/man3" \
		INCLUDEDIR="${EPREFIX}/usr/include" \
		install

	mv "${ED}"/usr/share/man/man3/{buffer.3,owfat-buffer.3} || die
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_STANDARD="95"
FORTRAN_NEEDED=fortran
inherit autotools fortran-2 flag-o-matic

DESCRIPTION="Reference implementation of the Dirfile, format for time-ordered binary data"
HOMEPAGE="https://getdata.sourceforge.net"
SRC_URI="https://github.com/ketiltrout/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="LGPL-2.1+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 cxx debug flac fortran lzma perl static-libs"

DEPEND="
	dev-libs/libltdl
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.0-fix-gzseek64-not-found.patch
	"${FILESDIR}"/${PN}-0.11.0-bashisms-configure.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	#
	# In theory I could report a bug. In practice the project has ignored all
	# bug reports since immediately after switching to github.
	filter-lto

	# GCC 10 workaround
	# bug #723076
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	econf \
		--disable-idl \
		--disable-matlab \
		--disable-php \
		--with-libz \
		--without-libslim \
		--without-libzzip \
		$(use_with bzip2 libbz2) \
		$(use_enable cxx cplusplus) \
		$(use_enable debug) \
		$(use_with flac libFLAC) \
		$(use_enable fortran) \
		$(use_enable fortran fortran95) \
		$(use_with lzma liblzma) \
		$(use_enable perl) \
		$(usex perl --with-perl-dir=vendor) \
		--disable-python \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

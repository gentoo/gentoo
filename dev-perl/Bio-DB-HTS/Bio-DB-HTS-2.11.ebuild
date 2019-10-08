# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=AVULLO
DIST_VERSION=2.11

inherit perl-module

DESCRIPTION="Perl bindings for sci-libs/htslib"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="sci-biology/bioperl
	sci-libs/htslib:="
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-LeakTrace )"

PATCHES=(
	"${FILESDIR}/2.11-build_split_htslib_opts.patch"
)

src_configure() {
	local myconf="--htslib-includedir=${EPREFIX}/usr/include/htslib --htslib-libdir=${EPREFIX}/usr/$(get_libdir)"
	perl-module_src_configure
}

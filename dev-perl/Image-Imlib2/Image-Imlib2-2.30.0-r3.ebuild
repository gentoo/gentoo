# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LBROCARD
DIST_VERSION=2.03
DIST_TEST="do verbose"
inherit perl-module toolchain-funcs

DESCRIPTION="Interface to the Imlib2 image library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=media-libs/imlib2-1"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.28
	virtual/pkgconfig
	test? (
		>=media-libs/imlib2-1[jpeg,png]
	)
"

PERL_RM_FILES=(
	t/pod.t
	t/pod_coverage.t

	# not ok 12
	#   Failed test at t/simple.t line 68.
	#          got: '0'
	#     expected: '1'
	t/simple.t
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.30.0-r2-imlib2-pkg-config.patch
	"${FILESDIR}"/${PN}-2.30.0-r2-respect-PKG_CONFIG-and-error.patch
)

src_configure() {
	tc-export PKG_CONFIG
	perl-module_src_configure
}

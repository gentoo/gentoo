# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DMUEY
DIST_VERSION=0.23
DIST_EXAMPLES=("example.pl")
inherit perl-module

DESCRIPTION="Perl access to the TCP Wrappers interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-apps/tcp-wrappers"
DEPEND="dev-perl/Module-Build"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		dev-perl/Test-Exception
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.23-inc-paths.patch"
)

PERL_RM_FILES=(
	t/03_pod.t
	t/02_maintainer.t
)

src_configure() {
	GENTOO_INCDIR="${EPREFIX}/usr/include" \
		GENTOO_LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		perl-module_src_configure
}

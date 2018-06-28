# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=AVULLO
DIST_VERSION=2.10

inherit perl-module

DESCRIPTION="Perl bindings for sci-libs/htslib"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="sci-biology/bioperl
	sci-libs/htslib:="
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-LeakTrace )"

PATCHES=(
	"${FILESDIR}/2.10-build_search_for_so.patch"
)

src_configure() {
	local myconf="--htslib=${EPREFIX}/usr"
	perl-module_src_configure
}

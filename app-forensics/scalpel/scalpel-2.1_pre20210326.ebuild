# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools flag-o-matic

DESCRIPTION="A high performance file carver"
HOMEPAGE="https://github.com/sleuthkit/scalpel"
SCALPEL_COMMIT="35e1367ef2232c0f4883c92ec2839273c821dd39"
SRC_URI="https://github.com/sleuthkit/scalpel/archive/${SCALPEL_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/scalpel-${SCALPEL_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/tre"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/gcc-11-fix-literal-suffix.patch" )
DOCS=( Changelog README )

src_prepare() {
	# Set the default config file location
	sed -e "s:scalpel.conf:/etc/\0:" -i src/scalpel.h || die "sed failed"

	sed -e 's|AM_CPPFLAGS =.*|AM_CPPFLAGS = -std=c++11|' -i Makefile.am src/Makefile.am || die "sed failed"

	# #716104 compile with musl misses error.h, solution borrowed from #701478
	if use elibc_musl; then
		eapply "${FILESDIR}/musl-error_h.patch"
	fi

	default
	eautoreconf

	filter-lto # https://bugs.gentoo.org/865687
}

src_install() {
	default

	insinto /etc
	doins scalpel.conf
}

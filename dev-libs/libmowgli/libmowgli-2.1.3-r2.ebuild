# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="https://github.com/atheme/libmowgli-2"
SRC_URI="https://github.com/atheme/libmowgli-2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ssl"

RDEPEND="ssl? (
		dev-libs/openssl:0=
	)
	!~dev-libs/libmowgli-2.1.0" # Bug 629644
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README doc/BOOST doc/design-concepts.txt )
PATCHES=(
	"${FILESDIR}"/${P}-cacheline-Ensure-sysconf-var-is-defined-before-use.patch
	"${FILESDIR}"/${P}-use-host-tools-for-ar-and-ranlib.patch
)

S="${WORKDIR}/${PN}-2-${PV}"

src_prepare() {
	default

	# $(MAKE) invocation will handle passing down flags.
	sed -i -e 's/${MFLAGS}//' buildsys.mk.in || die

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf $(use_with ssl openssl)
}

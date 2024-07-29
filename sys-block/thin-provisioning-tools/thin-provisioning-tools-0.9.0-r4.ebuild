# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="https://github.com/jthornber/thin-provisioning-tools"

if [[ ${PV} != *9999 ]]; then
	SRC_URI="https://github.com/jthornber/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
else
	inherit git-r3
	EGIT_REPO_URI='https://github.com/jthornber/thin-provisioning-tools.git'
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="static test"
RESTRICT="!test? ( test )"

LIB_DEPEND="dev-libs/expat[static-libs(+)]
	dev-libs/libaio[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	test? (
		>=dev-cpp/gtest-1.8.0
	)
	dev-libs/boost"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-build-fixes.patch
	"${FILESDIR}"/${PN}-0.9.0-build-fixes.patch
	"${FILESDIR}"/0.9.0-remove-boost_iostreams.patch
	"${FILESDIR}"/${PN}-0.9.0-metadata_checker-Rename-function-to-reflect-command-.patch
	"${FILESDIR}"/${PN}-0.9.0-thin_check-Allow-using-clear-needs-check-and-skip-ma.patch
	"${FILESDIR}"/${PN}-0.9.0-boost-gtest.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	local myeconfargs=(
		--prefix="${EPREFIX}"/
		--bindir="${EPREFIX}"/sbin
		--with-optimisation=''
		$(use_enable test testing)
	)
	STRIP=true econf "${myeconfargs[@]}"
}

src_compile() {
	emake V=
}

src_test() {
	emake V= unit-test
}

src_install() {
	emake V= DESTDIR="${D}" DATADIR="${ED}/usr/share" install
	dodoc README.md TODO.org
}

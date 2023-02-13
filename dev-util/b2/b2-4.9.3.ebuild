# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic toolchain-funcs

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A system for large project software construction, simple to use and powerful"
HOMEPAGE="https://www.bfgroup.xyz/b2/"
SRC_URI="https://github.com/bfgroup/b2/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"
RESTRICT="test"

RDEPEND="!dev-util/boost-build"

PATCHES=(
	"${FILESDIR}"/${PN}-4.9.2-disable_python_rpath.patch
	"${FILESDIR}"/${PN}-4.9.2-darwin-gentoo-toolchain.patch
	"${FILESDIR}"/${PN}-4.9.2-add-none-feature-options.patch
	"${FILESDIR}"/${PN}-4.9.2-no-implicit-march-flags.patch
	"${FILESDIR}"/${PN}-4.9.2-odr.patch
)

src_configure() {
	# need to enable LFS explicitly for 64-bit offsets on 32-bit hosts (#761100)
	append-lfs-flags
}

src_compile() {
	cd engine || die

	# upstream doesn't want separate flags for CPPFLAGS/LDFLAGS
	# https://github.com/bfgroup/b2/pull/187#issuecomment-1335688424
	edo ${CONFIG_SHELL:-${BASH}} ./build.sh cxx --cxx="$(tc-getCXX)" --cxxflags="${CXXFLAGS} ${CPPFLAGS} ${LDFLAGS}" -d+2 --without-python
}

src_test() {
	# Forget tests, b2 is a lost cause
	:
}

src_install() {
	dobin engine/b2

	insinto /usr/share/b2/src
	doins -r "${FILESDIR}/site-config.jam" \
		bootstrap.jam build-system.jam ../example/user-config.jam \
		build kernel options tools util

	find "${ED}"/usr/share/b2/src -iname '*.py' -delete || die

	dodoc ../notes/{changes,release_procedure,build_dir_option,relative_source_paths}.txt

	if use examples; then
		docinto examples
		dodoc -r ../example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

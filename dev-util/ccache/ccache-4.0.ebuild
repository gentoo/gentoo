# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="fast compiler cache"
HOMEPAGE="https://ccache.dev/"
SRC_URI="https://github.com/ccache/ccache/releases/download/v${PV}/ccache-${PV}.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}
	dev-util/shadowman
	sys-apps/gentoo-functions"
# clang-specific tests use dev-libs/elfutils to compare objects for equality.
# Let's pull in the dependency unconditionally.
DEPEND+="
	test? ( dev-libs/elfutils )"

RESTRICT="!test? ( test )"

DOCS=( doc/{AUTHORS,MANUAL,NEWS}.adoc CONTRIBUTING.md README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-nvcc-test.patch
	"${FILESDIR}"/${PN}-4.0-objdump.patch
	"${FILESDIR}"/${PN}-4.0-avoid-run-user.patch
	"${FILESDIR}"/${PN}-4.0-atomic.patch
)

# ccache does not do it automatically. TODO: fix upstream
need_latomic() {
	# test if -latomic is needed and helps. -latomic is needed
	# at least on ppc32. Use bit of inodeCache.cpp test.
	cat >"${T}"/a-test.cc <<-EOF
	#include <atomic>
	#include <cstdint>
	std::atomic<std::int64_t> a;
	int main() { return a.load() == 0; }
	EOF

	local cxx_cmd=(
		$(tc-getCXX)
		$CXXFLAGS
		$LDFLAGS
		"${T}"/a-test.cc
		-o "${T}"/a-test
	)

	einfo "${cxx_cmd[@]}"
	"${cxx_cmd[@]}" && return 1

	einfo "Trying to add -latomic"
	einfo "${cxx_cmd[@]}"
	cxx_cmd+=(-latomic)
	"${cxx_cmd[@]}" && return 0

	return 1
}

src_prepare() {
	cmake_src_prepare

	sed \
		-e "/^EPREFIX=/s:'':'${EPREFIX}':" \
		"${FILESDIR}"/ccache-config-3 > ccache-config || die

	# mainly used in tests
	tc-export CC OBJDUMP
}

src_configure() {
	local mycmakeargs=(
		-DLINK_WITH_ATOMIC=$(need_latomic && echo YES || echo NO)
	)
	cmake_src_configure
}

src_install() {
	# TODO: install manpage: https://github.com/ccache/ccache/issues/684
	cmake_src_install

	dobin ccache-config
	insinto /usr/share/shadowman/tools
	newins - ccache <<<"${EPREFIX}/usr/lib/ccache/bin"
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${ROOT:-/} == / ]] ; then
		eselect compiler-shadow remove ccache
	fi
}

pkg_postinst() {
	if [[ ${ROOT:-/} == / ]]; then
		eselect compiler-shadow update ccache
	fi
}

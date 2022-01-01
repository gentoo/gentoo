# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
SRC_URI="https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
# Try again after 0.9.6
RESTRICT="test"

RDEPEND=">=dev-cpp/tbb-2021.4.0:=
	dev-libs/xxhash:=
	sys-libs/zlib
	!kernel_Darwin? (
		dev-libs/mimalloc:=
		dev-libs/openssl:=
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.6-respect-flags.patch
)

src_prepare() {
	default

	sed -i \
		-e '/	strip/d' \
		-e '/	gzip/d' \
		-e "s:\$(DEST)/lib:\$(DEST)/$(get_libdir):" \
		Makefile || die

	# Needs unpackaged dwarfutils
	rm test/compressed-debug-info.sh \
		test/compress-debug-sections.sh || die

	# Seems to have been fixed in git (> 0.9.6)
	# Broken atm?
	rm test/mold-wrapper.sh || die

	# Needs llvmgold
	rm test/hello-static.sh || die
}

src_compile() {
	tc-export CC CXX

	emake \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_CXXFLAGS="${CXXFLAGS}" \
		EXTRA_CPPFLAGS="${CPPFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}"
}

src_test() {
        emake \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_CXXFLAGS="${CXXFLAGS}" \
		EXTRA_CPPFLAGS="${CPPFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		check
}

src_install() {
	emake \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_CXXFLAGS="${CXXFLAGS}" \
		EXTRA_CPPFLAGS="${CPPFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		DESTDIR="${ED}" \
		install
}

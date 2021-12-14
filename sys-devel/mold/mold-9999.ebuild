# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/rui314/mold.git"
	inherit git-r3
else
	SRC_URI="https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="AGPL-3"
SLOT="0"

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
	"${FILESDIR}"/${PN}-9999-build-respect-user-FLAGS.patch
	"${FILESDIR}"/${PN}-9999-don-t-compress-man-page.patch
)

src_compile() {
	tc-export CC CXX

	emake \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_CXXFLAGS="${CXXFLAGS}" \
		EXTRA_CPPFLAGS="${CPPFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		STRIP="true"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_test() {
	emake \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_CXXFLAGS="${CXXFLAGS}" \
		EXTRA_CPPFLAGS="${CPPFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		STRIP="true"
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
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		STRIP="true" \
		install
}

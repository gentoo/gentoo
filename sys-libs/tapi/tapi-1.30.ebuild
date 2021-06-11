# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Text-based Application Programming Interface"
HOMEPAGE="https://opensource.apple.com/source/tapi"
SRC_URI="https://opensource.apple.com/tarballs/${PN}/${P}.tar.gz"
S="${WORKDIR}/lib${P}"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~x64-macos"

DOCS=( Readme.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.30-llvm-out-of-tree.patch
	"${FILESDIR}"/${PN}-1.30-llvm-new-error-api.patch
	"${FILESDIR}"/${PN}-1.30-llvm-config.patch
	"${FILESDIR}"/${PN}-1.30-allow-all-clients.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/lib/cmake/llvm;${EPREFIX}/usr/share/llvm/cmake"
	)

	# poor man's configure
	[ -f "${EPREFIX}"/usr/include/llvm/Support/Error.h ] && \
		append-cxxflags -DLLVM_NEW_ERROR_API=1

	append-cxxflags -std=c++11
	cmake-utils_src_configure
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake flag-o-matic toolchain-funcs

DESCRIPTION="GNUstep Objective-C runtime"
HOMEPAGE="https://gnustep.github.io"
SRC_URI="https://github.com/gnustep/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-cpp/robin-map"
BDEPEND="${RDEPEND}
	llvm-core/clang"

PATCHES=(
	"${FILESDIR}"/libobjc-2.2.1-remove-flags-from-eh_trampoline.patch
)

src_configure() {
	if tc-is-gcc; then
		einfo "Forcing clang"
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"

		# Strip unsupported flags for clang. bug #871933
		strip-unsupported-flags
	fi

	local mycmakeargs=(
		-DGNUSTEP_CONFIG=GNUSTEP_CONFIG-NOTFOUND
		-DTESTS="$(usex test)"
	)
	cmake_src_configure
}

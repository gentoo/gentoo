# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="The HTML5 parsing algorithm implemented as a pure C99 library"
HOMEPAGE="https://codeberg.org/gumbo-parser/gumbo-parser"
SRC_URI="https://codeberg.org/grisha/gumbo-parser/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/gumbo-parser"

LICENSE="Apache-2.0"
SLOT="0/3" # gumbo SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}/gumbo-0.13.1-PR12-default_library.patch"
	"${FILESDIR}/gumbo-0.13.1-gtest.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		-Ddefault_library=shared
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile

	if use doc; then
		doxygen || die "doxygen failed"
		HTML_DOCS=( docs/html/. )
	fi
}

src_install() {
	meson_src_install

	use doc && doman docs/man/man3/*
}

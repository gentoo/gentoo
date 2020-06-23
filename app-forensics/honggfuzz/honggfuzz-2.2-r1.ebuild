# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A general purpose fuzzer with feedback support"
HOMEPAGE="https://google.github.io/honggfuzz/"
SRC_URI="https://github.com/google/honggfuzz/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=sys-libs/binutils-libs-2.29:=
	sys-libs/libunwind:=
	app-arch/xz-utils
"

DEPEND="${RDEPEND}"

DOCS=(
	CHANGELOG
	COPYING
	CONTRIBUTING
	README.md
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-no-werror.patch
)

pkg_pretend() {
	if tc-is-clang; then
		die "${P} does not work on clang due to incomplete -fblock support: https://bugs.gentoo.org/729256. Please try gcc."
	fi
}

src_prepare() {
	default
	tc-export AR CC
	export CFLAGS
	export LDFLAGS
}

src_install() {
	dobin ${PN}

	einstalldocs
}

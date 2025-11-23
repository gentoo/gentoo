# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Foreign function interface for bash"
HOMEPAGE="http://ctypes.sh/"
SRC_URI="https://github.com/taviso/${PN/-/.}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	app-shells/bash:=[plugins(-)]
	dev-libs/libffi:=
	virtual/libelf
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_test() {
	pushd test >/dev/null || die
	PATH="${S}:${PATH}" \
		LD_LIBRARY_PATH="${S}/src/.libs" \
		make CC="$(tc-getCC)" || die "make check failed"
	popd > /dev/null || die
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Foreign function interface for bash"
HOMEPAGE="http://ctypes.sh/"
SRC_URI="https://github.com/taviso/${PN/-/.}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/libffi
	virtual/libelf
	app-arch/xz-utils
	app-arch/bzip2
	app-shells/bash[plugins]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-makefile-fix.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_test() {
	pushd test
	PATH="${S}:${PATH}" \
		LD_LIBRARY_PATH="${S}/src/.libs" \
		make CC="$(tc-getCC)" || die "make check failed"
	popd
}

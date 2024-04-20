# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${P/_p/.update}"

DESCRIPTION="R6RS-compliant Scheme implementation for real-time applications"
HOMEPAGE="http://www.littlewingpinball.com/doc/en/ypsilon"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="app-alternatives/cpio"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-clang-cflags.patch
)

src_prepare() {
	default

	append-flags -pthread
	# fix build with >=sys-devel/gcc-11, bug #787866
	sed -i "/^CPPFLAGS/s/=/= -DNO_TLS/" Makefile

	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/858257
	#
	# There is an upstream update to 2.0.8 (lotta new versions!) but it changes
	# way too much to trivially update. The issue may or may not be fixed.
	# Before multiple other things bombed out, the erroring source file
	# *seemed* to compile ok.
	append-flags -fno-strict-aliasing
	filter-lto
}

src_compile() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		AS="$(tc-getAS)" \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}" \
		install

	if use examples; then
		docinto examples
		dodoc example/*
	fi
}

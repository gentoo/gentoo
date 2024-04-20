# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/vasi/${PN}.git"
	inherit git-r3 autotools
else
	SRC_URI="https://github.com/vasi/pixz/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="Parallel Indexed XZ compressor"
HOMEPAGE="https://github.com/vasi/pixz"

LICENSE="BSD-2"
SLOT="0"
IUSE="static"

LIB_DEPEND="
	>=app-arch/libarchive-2.8:=[static-libs(+)]
	>=app-arch/xz-utils-5[static-libs(+)]
"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
[[ ${PV} == 9999 ]] && BDEPEND+=" app-text/asciidoc"

src_prepare() {
	default

	# We're not interested in linting tests for our purposes (bug #915008)
	cat > test/cppcheck-src.sh <<-EOF || die
	#!/bin/sh
	exit 77
	EOF

	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	append-flags -std=gnu99

	# Workaround silly logic that breaks cross-compiles.
	# https://github.com/vasi/pixz/issues/67
	export ac_cv_file_src_pixz_1=$([[ -f src/pixz.1 ]] && echo yes || echo no)
	econf
}

src_install() {
	default

	# https://github.com/vasi/pixz/issues/94
	[[ ${PV} == "9999" ]] || doman src/pixz.1
}

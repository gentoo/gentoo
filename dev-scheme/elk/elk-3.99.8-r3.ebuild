# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Scheme implementation designed to be embeddable extension to C/C++ applications"
HOMEPAGE="http://sam.zoy.org/elk/"
SRC_URI="http://sam.zoy.org/elk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${P}-implicit-int-incompat-ptr.patch
	"${FILESDIR}"/${P}-implicit-function.patch
	"${FILESDIR}"/${P}-c99-build-fix.patch
	"${FILESDIR}"/${P}-makefile-ordering.patch
	"${FILESDIR}"/${P}-fpurge.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	#uses functional polymorphism, can't be ported to C23
	append-cflags -std=gnu17

	econf --disable-static
}

src_test() {
	# gc test is noted flakey and always fails when build with clang
	if tc-is-gcc; then
		emake check
	fi
}

src_install() {
	# parallel install is broken
	emake -j1 DESTDIR="${D}" \
		docsdir="${EPREFIX}"/usr/share/doc/${PF} \
		examplesdir="${EPREFIX}"/usr/share/doc/${PF}/examples \
		install
	einstalldocs
	docompress -x /usr/share/doc/${PF}

	# no static archives
	find "${D}" -name '*.la' -delete || die
}

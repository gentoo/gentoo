# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Persistent Memory Development Kit"
HOMEPAGE="https://pmem.io/ https://github.com/pmem/pmdk"
SRC_URI="https://github.com/pmem/pmdk/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64"

DEPEND="
	sys-block/ndctl:=
	sys-block/libfabric:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/pandoc
	virtual/pkgconfig
"

DOCS=(
	CODING_STYLE.md
	CONTRIBUTING.md
	ChangeLog
	README.md
)

src_prepare() {
	default

	# don't pre-compress man pages
	sed -e 's/:=.gz//g ; s:gzip -nc:cat:g' -i doc/Makefile || die

	# remove -Werror
	find . -name 'Makefile*' -type f -print | xargs sed 's:-Werror::g' -i || die
}

src_configure() {
	# doesn't build with -mindirect-branch=thunk
	filter-flags -mindirect-branch=thunk
}

src_compile() {
	emake DEBUG= CC=$(tc-getCC) CXX=$(tc-getCXX) LD=$(tc-getLD) AR=$(tc-getAR)
}

src_install() {
	emake install prefix=/usr sysconfdir=/etc DESTDIR="${ED}"
}

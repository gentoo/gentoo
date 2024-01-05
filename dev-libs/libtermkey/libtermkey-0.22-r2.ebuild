# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Library for easy processing of keyboard entry from terminal-based programs"
HOMEPAGE="http://www.leonerd.org.uk/code/libtermkey/"
SRC_URI="http://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"
IUSE="demos"

RDEPEND="dev-libs/unibilium:="
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	demos? ( dev-libs/glib:2 )
"

PATCHES=(
	"${FILESDIR}"/no-automagic-manpages-compress.patch
	"${FILESDIR}"/${PN}-0.22-libtool.patch # 913482
)

src_prepare() {
	default

	if ! use demos; then
		sed -e '/^all:/s:$(DEMOS)::' -i Makefile.in || die
	fi

	append-flags -fPIC

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die
	doman "${S}"/man/*.3
	doman "${S}"/man/*.7
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools bash-completion-r1

DESCRIPTION="A code-searching tool similar to ack, but faster"
HOMEPAGE="https://github.com/ggreer/the_silver_searcher"
SRC_URI="https://github.com/ggreer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips ~ppc ~ppc64 x86"
IUSE="lzma test zlib"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libpcre
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		dev-util/cram
		dev-vcs/git
	)"

DOCS="README.md"

src_prepare() {
	sed '/^dist_bashcomp/d' -i Makefile.am || die

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable lzma) \
		$(use_enable zlib)
}

src_test() {
	cram -v tests/*.t || die "tests failed"
}

src_install() {
	default
	newbashcomp ag.bashcomp.sh ag
}

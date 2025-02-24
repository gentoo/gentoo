# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Tool for editing VCS repositories and translating among different systems"
HOMEPAGE="http://www.catb.org/~esr/reposurgeon/"
SRC_URI="http://www.catb.org/~esr/${PN}/${P}.tar.xz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/dev-vcs/${PN}/${P}-deps.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/xmlto
	dev-ruby/asciidoctor
	virtual/pkgconfig
	test? ( dev-vcs/subversion )
"

src_prepare() {
	default
	sed -e 's/GOFLAGS/MY_GOFLAGS/g' -i "${S}/Makefile" || die
}

src_compile() {
	emake all
}

src_test() {
	emake TESTOPTS="-v" test
}

src_install() {
	emake DESTDIR="${ED}" prefix="/usr" docdir="share/doc/${PF}" install
}

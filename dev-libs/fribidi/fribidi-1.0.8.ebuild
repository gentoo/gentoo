# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"
HOMEPAGE="https://fribidi.org/"
SRC_URI="https://github.com/fribidi/fribidi/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=""
DEPEND=""
BDEPEND="
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

DOCS=( AUTHORS NEWS ChangeLog THANKS ) # README points at README.md which wasn't disted with EAPI-7

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
		--disable-debug
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

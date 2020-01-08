# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="line editing library for UNIX call compatible with the FSF readline"
HOMEPAGE="http://troglobit.com/projects/editline/"
SRC_URI="https://github.com/troglobit/editline/releases/download/${PV}/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=("${FILESDIR}"/${PN}-1.16.0-rename-man.patch)

src_prepare() {
	default

	# To avoid collision with dev-libs/libedit
	# we rename man/editline.3 to man/libeditline.3
	mv man/editline.3 man/libeditline.3 || die
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# package installs .pc file
	find "${D}" -name '*.la' -delete || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs autotools

DESCRIPTION="A better and stronger spiritual successor to BZip2"
HOMEPAGE="https://github.com/kspalaiologos/bzip3"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kspalaiologos/${PN}.git"
else
	SRC_URI="https://github.com/kspalaiologos/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-3+"
SLOT="0"
IUSE="static-libs"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# ./configure script will default to Clang if it is found on the system,
	# force the use of CC selected by the user with CC=$(tc-getCC)
	econf $(use_enable static-libs static) CC=$(tc-getCC)
}

src_install() {
	default

	if ! use static-libs ; then
		find "${ED}" -type f -name '*.la' -delete || die
	fi
}

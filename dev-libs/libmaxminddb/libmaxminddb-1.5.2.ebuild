# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C library for the MaxMind DB file format"
HOMEPAGE="https://github.com/maxmind/libmaxminddb"
SRC_URI="https://github.com/maxmind/libmaxminddb/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/0.0.7"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-perl/IPC-Run3 )"

DOCS=( Changes.md )

src_configure() {
	econf --disable-static
	tc-export AR CC
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

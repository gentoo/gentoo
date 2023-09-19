# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="C library for the MaxMind DB file format"
HOMEPAGE="https://github.com/maxmind/libmaxminddb"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/maxmind/libmaxminddb.git"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/maxmind/libmaxminddb/releases/download/${PV}/${P}.tar.gz"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0/0.0.7"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-perl/IPC-Run3 )"

DOCS=( Changes.md )

src_prepare() {
	default

	if [[ ${PV} == *9999 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	tc-export AR CC

	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

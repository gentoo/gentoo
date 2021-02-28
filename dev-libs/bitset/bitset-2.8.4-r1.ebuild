# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A compressed bitset with supporting data structures and algorithms"
HOMEPAGE="https://github.com/chriso/bitset"
SRC_URI="https://github.com/chriso/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="jemalloc static-libs tcmalloc"
KEYWORDS="amd64 ~arm x86"

RDEPEND="
	tcmalloc? ( dev-util/google-perftools:= )
	jemalloc? ( >=dev-libs/jemalloc-3.2 )
"
DEPEND="${RDEPEND}"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

DOCS=( README.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local tcmalloc_lib_name='tcmalloc'

	has_version dev-util/google-perftools[minimal] && tcmalloc_lib_name='tcmalloc_minimal'

	local myeconfargs=(
		$(use_with jemalloc) \
		$(use_with tcmalloc) \
		$(use_with tcmalloc tcmalloc-lib "${tcmalloc_lib_name}")
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

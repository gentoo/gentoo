# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A compressed bitset with supporting data structures and algorithms"
HOMEPAGE="https://github.com/chriso/bitset"
SRC_URI="https://github.com/chriso/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs tcmalloc"

RDEPEND="
	tcmalloc? ( dev-util/google-perftools:= )
"
DEPEND="${RDEPEND}"

DOCS=( README.md )

src_prepare() {
	default

	# Disable aggressive optimization, which does not respect CFLAGS
	# with new autoconf, bug #815637
	sed -i -e '/AX_CC_MAXOPT/d' configure.ac || die

	eautoreconf
}

src_configure() {
	local tcmalloc_lib_name='tcmalloc'

	has_version dev-util/google-perftools[minimal] && tcmalloc_lib_name='tcmalloc_minimal'

	local myeconfargs=(
		$(use_with tcmalloc) \
		$(use_with tcmalloc tcmalloc-lib "${tcmalloc_lib_name}")
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bitset/bitset-2.8.4-r1.ebuild,v 1.3 2013/11/24 13:14:10 pinkbyte Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A compressed bitset with supporting data structures and algorithms"
HOMEPAGE="http://github.com/chriso/bitset"
SRC_URI="https://github.com/chriso/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="jemalloc static-libs tcmalloc"
KEYWORDS="amd64 ~arm x86"

RDEPEND="tcmalloc? ( dev-util/google-perftools:= )
	jemalloc? ( >=dev-libs/jemalloc-3.2 )"
DEPEND="${RDEPEND}"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

DOCS=( README.md )

src_configure() {
	local tcmalloc_lib_name='tcmalloc'
	has_version dev-util/google-perftools[minimal] && tcmalloc_lib_name='tcmalloc_minimal'
	local myeconfargs=(
		$(use_with jemalloc) \
		$(use_with tcmalloc) \
		$(use_with tcmalloc tcmalloc-lib "${tcmalloc_lib_name}")
	)
	autotools-utils_src_configure
}

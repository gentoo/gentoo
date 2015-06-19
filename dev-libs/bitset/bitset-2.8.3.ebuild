# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bitset/bitset-2.8.3.ebuild,v 1.4 2013/06/13 08:43:38 pinkbyte Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A compressed bitset with supporting data structures and algorithms"
HOMEPAGE="http://github.com/chriso/bitset"
SRC_URI="https://github.com/chriso/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="jemalloc static-libs tcmalloc"
KEYWORDS="amd64 x86"

RDEPEND="tcmalloc? ( dev-util/google-perftools[-minimal] )
	jemalloc? ( >=dev-libs/jemalloc-3.2 )"
DEPEND="${RDEPEND}"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

DOCS=( README.md )

src_configure() {
	local myeconfargs=(
		$(use_with jemalloc) \
		$(use_with tcmalloc)
	)
	autotools-utils_src_configure
}

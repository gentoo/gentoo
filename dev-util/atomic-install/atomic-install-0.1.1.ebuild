# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

DESCRIPTION="A library and tool to atomically install sets of files"
HOMEPAGE="https://github.com/mgorny/atomic-install/"
SRC_URI="mirror://github/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs xattr"

RDEPEND="xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.18 )"

src_configure() {
	myeconfargs=(
		$(use_enable doc gtk-doc)
		$(use_enable xattr libattr)
	)

	autotools-utils_src_configure
}

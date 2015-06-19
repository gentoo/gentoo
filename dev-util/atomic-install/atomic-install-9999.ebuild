# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/atomic-install/atomic-install-9999.ebuild,v 1.1 2012/12/15 12:45:07 mgorny Exp $

EAPI=4

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="git://github.com/mgorny/${PN}.git
	http://github.com/mgorny/${PN}.git"

inherit git-2
#endif

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

#if LIVE
KEYWORDS=
SRC_URI=
DEPEND="${DEPEND}
	>=dev-util/gtk-doc-1.18"
#endif

src_configure() {
	myeconfargs=(
		$(use_enable doc gtk-doc)
		$(use_enable xattr libattr)
	)

	autotools-utils_src_configure
}

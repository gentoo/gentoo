# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Reimplementation of Bourne shell based on pdksh"
HOMEPAGE="http://packages.debian.org/posh"
SRC_URI="mirror://debian/pool/main/p/posh/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"

src_prepare() {
	eapply "${FILESDIR}/${P}-test-perl-fix.patch"

	default

	# tarball bundles outdated generated files
	eautoreconf
}

src_configure() {
	local myconf=(
		--exec-prefix=/
	)
	econf "${myconf[@]}"
}

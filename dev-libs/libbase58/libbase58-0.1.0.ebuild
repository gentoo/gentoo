# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libbase58/libbase58-0.1.0.ebuild,v 1.1 2014/09/15 23:20:35 blueness Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="C implementation of Bitcoin's base58 encoding"
HOMEPAGE="https://github.com/luke-jr/libbase58"
LICENSE="MIT"

SRC_URI="https://github.com/luke-jr/${PN}/archive/v${PV}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="tools"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable tools tool)
	)
	autotools-utils_src_configure
}

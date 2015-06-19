# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/scrypt/scrypt-1.1.6.ebuild,v 1.2 2015/01/28 19:14:05 mgorny Exp $

EAPI=5

DESCRIPTION="A simple password-based encryption utility using the scrypt key derivation function"
HOMEPAGE="http://www.tarsnap.com/scrypt.html"
SRC_URI="http://www.tarsnap.com/${PN}/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2"

DOCS=( FORMAT )

src_configure() {
	econf $(use_enable cpu_flags_x86_sse2)
}

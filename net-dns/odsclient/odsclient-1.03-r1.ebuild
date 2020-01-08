# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Client for the Open Domain Server's dynamic dns"
HOMEPAGE="http://www.ods.org/"
SRC_URI="http://www.ods.org/dl/${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

PATCHES=( "${FILESDIR}/${PV}-gentoo.patch" )

src_prepare() {
	default
	sed -i Makefile -e 's| -o | $(LDFLAGS)&|g' || die "sed failed"
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin odsclient
	einstalldocs
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A portable file archiver using QuickLZ algorithm"
HOMEPAGE="http://www.quicklz.com/"
SRC_URI="http://www.quicklz.com/${PN}-${PV/./}-source.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_prepare() {
	default

	# Fix compilation with newer gcc
	sed -i '1i #include <unistd.h>' qpress.cpp || die
	cp "${FILESDIR}/makefile" "${S}" || die
}

src_install() {
	dobin ${PN}
}

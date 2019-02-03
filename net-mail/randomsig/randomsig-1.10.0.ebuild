# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${PN}-v${PV}

DESCRIPTION="randomsig - perl script for generating random .signature files"
HOMEPAGE="http://suso.suso.org/programs/randomsig/"
SRC_URI="http://suso.suso.org/programs/randomsig/downloads/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 s390 sparc x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	sed -e "s:/usr/local/bin:${EPREFIX}/usr/bin:" \
		-e "s:/usr/local/etc:${EPREFIX}/etc:" \
		-i Makefile || die
	sed -e "s:/usr/local/etc:${EPREFIX}/etc:" \
		-i randomsig || die
}

src_install() {
	dobin randomsig
	einstalldocs

	insinto /etc/randomsig
	doins .randomsigrc .sigquotes .sigcancel .sigread
}

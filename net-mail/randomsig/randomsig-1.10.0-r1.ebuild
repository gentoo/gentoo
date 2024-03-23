# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

DESCRIPTION="Perl script for generating random .signature files"
HOMEPAGE="https://suso.suso.org/xulu/Randomsig"
SRC_URI="https://suso.suso.org/programs/randomsig/downloads/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~s390 ~sparc ~x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

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

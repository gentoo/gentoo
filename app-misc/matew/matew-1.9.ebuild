# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Make Album The Easy Way (Matew) is an HTML/CSS generator for static image albums"
HOMEPAGE="http://inquisb.github.io/matew/"
SRC_URI="mirror://sourceforge/matew/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-gfx/imagemagick
	app-shells/bash
	sys-apps/coreutils
"

src_install() {
	dobin "${S}"/src/matew "${S}"/src/matew-cleanup "${S}"/src/matew-wizard
	insinto /etc/matew/styles
	doins "${S}"/src/styles/*
	insinto /etc/matew/languages
	doins "${S}"/src/languages/*
	dodoc "${S}"/doc/AUTHOR "${S}"/doc/ChangeLog "${S}"/doc/README \
		"${S}"/doc/THANKS "${S}"/doc/TODO
	doman "${S}"/doc/man/matew.1.gz
}

pkg_postinst() {
	elog "Matew files installed successfully!"
	elog "Run matew-wizard and read instructions."
}

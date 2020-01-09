# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool to analyze qmail activity with the goal to graph everything through MRTG"
HOMEPAGE="http://dev.publicshout.org/qmrtg"
SRC_URI="${HOMEPAGE}/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
PATCHES=(
	"${FILESDIR}"/mrtg.cfg.patch
	"${FILESDIR}"/qmrtg.conf.sample.patch
	"${FILESDIR}"/${P}-TAI_STR_LEN.patch
)

src_prepare() {
	default
	sed -i \
		-e 's|^CFLAGS =|CFLAGS ?=|g' \
		analyzers/Makefile.in filters/Makefile.in || die
}

DOCS=( INSTALL.txt )

src_install () {
	default

	keepdir /var/lib/qmrtg

	if use doc ; then
		docinto txt
		dodoc doc/*.txt
		docinto html
		dodoc -r html/*
	fi

	insinto /usr/share/qmrtg2
	doins examples/*
}

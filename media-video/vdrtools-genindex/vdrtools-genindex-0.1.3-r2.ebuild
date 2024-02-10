# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCRIPT="genindex"

DESCRIPTION="VDR: genindex Script"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://www.muempf.de/down/${SCRIPT}-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="amd64 x86"

S=${WORKDIR}/${SCRIPT}-${PV}

DOCS=( README )

src_prepare() {
	# respect LDFLAGS
	sed -i Makefile \
		-e "s:\$(CXXFLAGS) \$^:\$(CXXFLAGS) \$(LDFLAGS) \$^:" || die

	default
}

src_install() {
	dobin genindex
	einstalldocs
}

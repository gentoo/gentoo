# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit python-any-r1

DESCRIPTION="Finnish dictionary for libvoikko based spell checkers (vvfst format)"
HOMEPAGE="https://voikko.puimula.org/"
SRC_URI="https://www.puimula.org/voikko-sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/foma
	dev-libs/libvoikko"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}
	dev-libs/libvoikko"

src_compile() {
	emake vvfst
}

src_install() {
	emake DESTDIR="${D}/usr/share/voikko/" vvfst-install
	einstalldocs
}

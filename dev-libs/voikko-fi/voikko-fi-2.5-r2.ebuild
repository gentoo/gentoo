# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"

inherit python-any-r1 verify-sig

DESCRIPTION="Finnish dictionary for libvoikko based spell checkers (vvfst format)"
HOMEPAGE="https://voikko.puimula.org/"
SRC_URI="https://www.puimula.org/voikko-sources/${PN}/${P}.tar.gz
	verify-sig? ( https://www.puimula.org/voikko-sources/voikko-fi/${P}.tar.gz.asc )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/foma:=
	dev-libs/libvoikko"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}
	dev-libs/libvoikko
	verify-sig? ( sec-keys/openpgp-keys-voikko )"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/voikko.asc

src_compile() {
	emake GENLEX_OPTS="--extra-usage=education,human,it,medicine,nature,orgname,science" vvfst
}

src_install() {
	emake DESTDIR="${D}/usr/share/voikko/" vvfst-install
	einstalldocs
}

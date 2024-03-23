# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-r1 verify-sig

DESCRIPTION="Spell checking, hyphenation and morphological analysis tool for Finnish language"
HOMEPAGE="https://voikko.puimula.org/"
SRC_URI="https://www.puimula.org/voikko-sources/${PN}/${P}.tar.gz
	verify-sig? ( https://www.puimula.org/voikko-sources/libvoikko/${P}.tar.gz.asc )"

LICENSE="GPL-2+"
SLOT="0/1.16.2"
KEYWORDS="amd64 ~loong ~riscv x86"

IUSE="+expvfst +hfst verify-sig"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

DEPEND="${PYTHON_DEPS}
	hfst? ( >=dev-util/hfstospell-0.5.0 )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig
	>=dev-build/autoconf-2.71
	verify-sig? ( sec-keys/openpgp-keys-voikko )"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/voikko.asc

PATCHES=( "${FILESDIR}"/libvoikko-4.3.2-disable-wall-werror.patch )

src_configure() {
	local myconf=(
		--prefix=/usr
		--with-dictionary-path=/usr/share/voikko
		$(use_enable expvfst)
	)

	if ! use hfst ; then
		myconf+=( --disable-hfst )
	fi

	econf "${myconf[@]}"
}

src_install() {
	python_setup
	default

	python_foreach_impl python_domodule python/libvoikko.py

	find "${D}" -name '*.la' -delete -o -name '*.a' -delete || die
}

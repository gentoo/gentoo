# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unicode data from unicode.org"
HOMEPAGE="https://unicode.org/ucd/"
SRC_URI="https://unicode.org/Public/zipped/${PV}/UCD.zip -> ${P}-UCD.zip
	https://unicode.org/Public/zipped/${PV}/Unihan.zip -> ${P}-Unihan.zip"

LICENSE="unicode"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ~ppc64 ~riscv ~s390 sparc x86"

DEPEND="app-arch/unzip"
S="${WORKDIR}"

src_unpack() {
	# Unihan.zip needs to be installed as a zip for reverse deps
	# https://bugzilla.gnome.org/show_bug.cgi?id=768210
	unpack ${P}-UCD.zip
}

src_install() {
	insinto /usr/share/${PN}
	doins -r "${S}"/*
	newins "${DISTDIR}"/${P}-Unihan.zip Unihan.zip
}

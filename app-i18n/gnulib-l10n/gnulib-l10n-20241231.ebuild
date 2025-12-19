# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="af be bg ca cs da de el eo es et eu fi fr ga gl hu it ja ka ko ms nb nl pl pt pt_BR ro ru rw sk sl sr sv tr uk vi zh_CN zh_TW"
inherit plocale

DESCRIPTION="Localization for gnulib"
HOMEPAGE="https://www.gnu.org/software/gnulib/manual/html_node/Localization.html"
SRC_URI="mirror://gnu/gnulib/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_prepare() {
	default

	plocale_find_changes "po" "" ".po" || die

	delete_locale() {
		local locale=${1}
		rm po/${locale}{.po,.gmo} || die
	}

	plocale_for_each_disabled_locale delete_locale
}

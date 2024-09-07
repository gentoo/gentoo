# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A set of improved Artwiz fonts with bold and full ISO-8859-1 support"
HOMEPAGE="https://artwiz-latin1.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/artwiz-latin1/${P}.tgz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~alpha amd64 arm ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"

S="${WORKDIR}/${PN}"

DOCS="README AUTHORS VERSION CHANGELOG"
FONT_S="${S}"
FONT_SUFFIX="pcf.gz"

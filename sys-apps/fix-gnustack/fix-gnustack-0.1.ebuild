# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utility to report and remove the executable flag from an ELF object's GNU_STACK"
HOMEPAGE="https://dev.gentoo.org/~blueness/fix-gnustack"
SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"

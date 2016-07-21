# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Utility to report and remove the executable flag from an ELF object's GNU_STACK"
HOMEPAGE="https://dev.gentoo.org/~blueness/${PN}"
SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${P}.tar.bz2"
LICENSE="GPL-3"

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"

KEYWORDS="~amd64 ~x86"
SLOT="0"

S="${WORKDIR}/${PN}"

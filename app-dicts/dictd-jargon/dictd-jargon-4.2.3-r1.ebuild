# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit dict

MY_P=${PN/dictd-/}_${PV}
DESCRIPTION="Jargon lexicon"
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${MY_P}.tar.gz"

KEYWORDS="x86 sparc ppc amd64 ppc64"

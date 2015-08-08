# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A somewhat comprehensive collection of french Linux man pages"
HOMEPAGE="http://traduc.org/perkamon"
SRC_URI="http://alioth.debian.org/frs/download.php/3722/${P}.tar.bz2"

LICENSE="man-pages GPL-1+ GPL-2+ GPL-2 BSD BSD-2 MIT rc LDP-1 public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/man"
DEPEND=""

S="${WORKDIR}/fr"

src_install() {
	dodoc README.fr
	doman -i18n=fr man*/*
}

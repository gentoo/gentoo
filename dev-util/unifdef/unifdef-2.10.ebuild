# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/unifdef/unifdef-2.10.ebuild,v 1.2 2014/03/09 19:33:03 vapier Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="remove #ifdef'ed lines from a file while otherwise leaving the file alone"
HOMEPAGE="http://dotat.at/prog/unifdef/"
SRC_URI="http://dotat.at/prog/unifdef/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -sparc-fbsd -x86-fbsd ~amd64-linux ~x86-linux"

DOCS=( README )

src_prepare() {
	sed -i '/^prefix/s:=.*:=/usr:' Makefile || die
	tc-export CC
}

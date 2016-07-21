# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit flag-o-matic

DESCRIPTION="Reiserfs Utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/fs/reiserfs/"
SRC_URI="mirror://kernel/linux/utils/fs/reiserfs/${P}.tar.xz
	mirror://kernel/linux/kernel/people/jeffm/${PN}/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 -sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

src_configure() {
	append-flags -std=gnu89 #427300
	econf --prefix="${EPREFIX}/"
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Convert CD images from ccd (CloneCD) to iso"
HOMEPAGE="https://sourceforge.net/projects/ccd2iso/"
SRC_URI="mirror://sourceforge/ccd2iso/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

PATCHES=( "${FILESDIR}"/${P}-headers.patch )

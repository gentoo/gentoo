# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musepack-tools/musepack-tools-465-r1.ebuild,v 1.7 2014/01/19 10:25:14 ago Exp $

EAPI=5
inherit cmake-multilib

# svn export http://svn.musepack.net/libmpc/trunk musepack-tools-${PV}
# tar -cjf musepack-tools-${PV}.tar.bz2 musepack-tools-${PV}

DESCRIPTION="Musepack SV8 libraries and utilities"
HOMEPAGE="http://www.musepack.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=media-libs/libcuefile-${PV}[${MULTILIB_USEDEP}]
	>=media-libs/libreplaygain-${PV}[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r5
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )
	!media-libs/libmpcdec
	!media-libs/libmpcdecsv7"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-gentoo.patch" )

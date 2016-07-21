# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

inherit autotools-multilib

DESCRIPTION="library that provides direct access to the IEEE 1394 bus"
HOMEPAGE="https://ieee1394.wiki.kernel.org/"
SRC_URI="mirror://kernel/linux/libs/ieee1394/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="static-libs"

DEPEND="app-arch/xz-utils"
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r4
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

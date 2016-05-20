# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

inherit autotools-multilib

DESCRIPTION="Common library for accessing Microsoft Media Server (MMS) media streaming protocol"
HOMEPAGE="http://sourceforge.net/projects/libmms/ https://launchpad.net/libmms/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="abi_x86_32? (
		!<=app-emulation/emul-linux-x86-medialibs-20130224-r8
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

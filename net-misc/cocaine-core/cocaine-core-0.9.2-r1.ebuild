# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cocaine-core/cocaine-core-0.9.2-r1.ebuild,v 1.1 2014/09/08 11:19:19 pinkbyte Exp $

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Cloud platform, core parts"
HOMEPAGE="http://reverbrain.com/cocaine/"
SRC_URI="https://github.com/cocaine/${PN}/archive/${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/boost:=
	<net-libs/zeromq-3
	dev-libs/libev
	dev-libs/msgpack
	dev-libs/libcgroup
	"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-boost-1.53.patch" )

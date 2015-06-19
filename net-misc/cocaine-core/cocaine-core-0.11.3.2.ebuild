# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cocaine-core/cocaine-core-0.11.3.2.ebuild,v 1.1 2015/03/16 03:44:08 patrick Exp $

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Cloud platform, core parts"
HOMEPAGE="http://reverbrain.com/cocaine/"
SRC_URI="http://repo.reverbrain.com/precise/current/source/${PN}_${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/boost:=
	<net-libs/zeromq-3
	dev-libs/libev
	<dev-libs/msgpack-0.6
	dev-libs/libcgroup
	"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.11.2.5_binutils-2.23-compat.patch" )

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A FUSE filesystem for Rackspace's Cloud Files"
HOMEPAGE="http://redbo.github.io/cloudfuse/"
SRC_URI="https://github.com/redbo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/libxml2
	dev-libs/openssl:0
	net-misc/curl
	sys-fs/fuse
"

RDEPEND="${DEPEND}"

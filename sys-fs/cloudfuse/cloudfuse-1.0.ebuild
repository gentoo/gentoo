# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/cloudfuse/cloudfuse-1.0.ebuild,v 1.1 2015/07/19 15:08:36 alunduil Exp $

EAPI=5

inherit eutils

DESCRIPTION="A FUSE filesystem for Rackspace's Cloud Files"
HOMEPAGE="http://redbo.github.io/cloudfuse/"
SRC_URI="https://github.com/redbo/${PN}/archive/${PV}.tar.gz"
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

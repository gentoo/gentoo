# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nipper/nipper-0.12.0.ebuild,v 1.2 2013/03/26 23:53:09 ikelos Exp $

EAPI="4"

inherit cmake-utils

DESCRIPTION="Router configuration security analysis tool"
HOMEPAGE="http://nipper.titania.co.uk/"
SRC_URI="mirror://sourceforge/nipper/${PN}-cli-${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=net-libs/libnipper-0.12"
RDEPEND=""

S=${WORKDIR}/${PN}-cli-${PV}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/prison/prison-1.1.1.ebuild,v 1.5 2014/08/02 18:10:50 ago Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="QRCode and data matrix barcode library"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/prison"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd"
SLOT="4"
IUSE="debug"

DEPEND="
	media-gfx/qrencode
	media-libs/libdmtx
"
RDEPEND="${DEPEND}"

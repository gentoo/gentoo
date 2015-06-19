# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/erfa/erfa-1.0.1.ebuild,v 1.1 2013/11/26 17:18:15 bicatali Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Essential Routines for Fundamental Astronomy"
HOMEPAGE="https://github.com/liberfa/erfa"
SRC_URI="https://github.com/liberfa/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT=0
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

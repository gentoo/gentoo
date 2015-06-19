# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/MicroJSON/MicroJSON-0.3.1.ebuild,v 1.4 2014/08/10 20:32:40 slyfox Exp $

EAPI="5"

inherit cmake-utils

DESCRIPTION="Small and simple to use JSON generation and parsing library"
HOMEPAGE="http://grigory.info/${PN}.About.html"
SRC_URI="http://grigory.info/distfiles/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND=">=dev-libs/UTF8Strings-1.12.0"

DEPEND="${RDEPEND}"

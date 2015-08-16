# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Essential Routines for Fundamental Astronomy"
HOMEPAGE="https://github.com/liberfa/erfa"
SRC_URI="https://github.com/liberfa/erfa/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

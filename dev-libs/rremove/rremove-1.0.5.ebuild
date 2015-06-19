# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/rremove/rremove-1.0.5.ebuild,v 1.1 2012/03/01 06:59:25 radhermit Exp $

EAPI="4"

inherit autotools-utils

DESCRIPTION="A simple library to recursively delete non-empty directories"
HOMEPAGE="https://frigidcode.com/code/rremove/"
SRC_URI="https://frigidcode.com/code/rremove/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools-utils

DESCRIPTION="A simple library to recursively delete non-empty directories"
HOMEPAGE="https://frigidcode.com/code/rremove/"
SRC_URI="https://frigidcode.com/code/rremove/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="FSRunner give you instant access to any file or directory you need"
HOMEPAGE="https://code.google.com/p/fsrunner/"
SRC_URI="https://fsrunner.googlecode.com/files/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DOCS=( changelog README )

DEPEND="$(add_kdeapps_dep libkonq)"
RDEPEND="${DEPEND}"

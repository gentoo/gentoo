# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils ltprune

DESCRIPTION="library for Levenberg-Marquardt least-squares minimization and curve fitting"
HOMEPAGE="http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
SRC_URI="http://apps.jcns.fz-juelich.de/src/lmfit/old/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}

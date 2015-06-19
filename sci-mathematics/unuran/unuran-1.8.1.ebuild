# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/unuran/unuran-1.8.1.ebuild,v 1.8 2012/07/06 23:47:30 bicatali Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Universal Non-Uniform Random number generator"
HOMEPAGE="http://statmath.wu.ac.at/unuran/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples gsl prng +rngstreams static-libs"

DEPEND="
	gsl? ( sci-libs/gsl )
	prng? ( sci-mathematics/prng )
	rngstreams? ( sci-mathematics/rngstreams )"
RDEPEND="${DEPEND}"

src_configure() {
	local udefault=builtin
	use rngstreams && udefault=rngstream
	local myeconfargs=(
		--enable-shared
		--with-urng-default=${udefault}
		$(use_with gsl urng-gsl)
		$(use_with prng urng-prng)
		$(use_with rngstreams urng-rngstream)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/${PN}.pdf
	if use examples; then
		rm examples/Makefile*
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

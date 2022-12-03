# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit out-of-source

DESCRIPTION="Multiple independent streams of pseudo-random numbers"
HOMEPAGE="https://statmath.wu.ac.at/software/RngStreams/"
SRC_URI="https://statmath.wu.ac.at/software/RngStreams/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

my_src_configure() {
	# bash for bug #818532
	CONFIG_SHELL="${BROOT}"/bin/bash econf --enable-shared --disable-static
}

my_src_install_all() {
	if use doc; then
		HTML_DOCS=( doc/rngstreams.html/. )
		dodoc doc/${PN}.pdf
	fi
	einstalldocs

	if use examples; then
		rm examples/Makefile* || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	# no static archives
	find "${D}" -name '*.la' -delete || die
}

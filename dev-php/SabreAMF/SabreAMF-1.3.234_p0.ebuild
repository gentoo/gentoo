# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot

KEYWORDS="~amd64 ~x86"

DESCRIPTION="SabreAMF is a Flash Remoting server and client for PHP"
HOMEPAGE="https://github.com/evert/${PN}"
SRC_URI="https://github.com/evert/${PN}/archive/e5521c27e9309404d7505e1e16db843fcb2202ec.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE="examples"

DOCS=( README ChangeLog )

src_install() {
	insinto /usr/share/php/${PN}
	doins -r ${PN}/*
	einstalldocs
	if use examples ; then
		insinto /usr/share/doc/${P}/examples
		docompress -x /usr/share/doc/${P}/examples
		doins examples/*
	fi
}

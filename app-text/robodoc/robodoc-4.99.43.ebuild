# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automating Software Documentation"
HOMEPAGE="https://www.xs4all.nl/~rfsber/Robo/robodoc.html"
SRC_URI="https://rfsber.home.xs4all.nl/Robo/archives/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND=">=dev-util/ctags-5.3.1"
DEPEND="${RDEPEND}"

src_install() {
	default

	insinto /usr/share/${PN}
	doins Contributions/*

	if use examples; then
		insinto /usr/share/${PN}
		doins -r Examples/PerlExample
	fi
}

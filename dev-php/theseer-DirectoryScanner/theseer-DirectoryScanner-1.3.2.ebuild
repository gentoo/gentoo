# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="DirectoryScanner"

DESCRIPTION="A recursive directory scanner and filter"
HOMEPAGE="https://github.com/theseer/DirectoryScanner"
SRC_URI="https://github.com/theseer/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~s390 sparc x86"

RDEPEND="dev-lang/php:*"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /usr/share/php/TheSeer/${MY_PN}
	doins -r src/*

	einstalldocs
}

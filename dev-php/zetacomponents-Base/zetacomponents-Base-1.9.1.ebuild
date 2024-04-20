# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Base"

DESCRIPTION="Base package for any Zeta component"
HOMEPAGE="https://github.com/zetacomponents/Base"
SRC_URI="https://github.com/zetacomponents/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~s390 sparc x86"

RDEPEND="dev-lang/php:*"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /usr/share/php/ezc/${MY_PN}
	doins -r src/*
	doins "${FILESDIR}"/autoload.php

	einstalldocs
}

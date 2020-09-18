# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="899ca665a0cb725990c33415dc3c0261dac7fe46"

inherit cmake

DESCRIPTION="Perpetual date converter from gregorian to poee calendar"
HOMEPAGE="https://github.com/bo0ts/ddate"
SRC_URI="https://github.com/bo0ts/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 arm arm64 x86"
LICENSE="public-domain"
SLOT="0"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

PATCHES=( "${FILESDIR}/${PN}-0.2.2-dont-compress-manpage.patch" )

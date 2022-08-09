# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Icinga PHP libraries for Icinga Web 2"
HOMEPAGE="https://github.com/Icinga/icinga-php-library"
MY_GITHUB_AUTHOR="Icinga"
SRC_URI="https://github.com/${MY_GITHUB_AUTHOR}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	insinto "/usr/share/icinga-php/ipl"
	cd "${S}"
	doins -r *
}

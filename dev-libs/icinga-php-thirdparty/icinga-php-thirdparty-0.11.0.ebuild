# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Icinga PHP libraries for Icinga Web 2"
HOMEPAGE="https://github.com/Icinga/icinga-php-thirdparty"
SRC_URI="https://github.com/Icinga/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/icinga-php/vendor"
	cd "${S}"
	doins -r *
}

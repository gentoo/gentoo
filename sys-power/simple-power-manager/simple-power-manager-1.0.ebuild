# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A programmable shell daemon that performs actions based on power thresholds"
HOMEPAGE="https://github.com/a-schaefers/simple-power-manager"
SRC_URI="https://github.com/a-schaefers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-power/acpi"

src_install() {
	dobin simple-power-manager
}

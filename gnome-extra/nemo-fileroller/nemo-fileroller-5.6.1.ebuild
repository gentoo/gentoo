# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Nemo file-roller integration"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/nemo-extensions"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/nemo-fileroller-5.6.1.tar.gz -> nemo-extensions-5.6.1.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

DEPEND="
	>=dev-libs/glib-2.14.0
	>=gnome-extra/nemo-2.0.0
"
RDEPEND="
	${DEPEND}
	app-arch/file-roller
"

S="${WORKDIR}/nemo-extensions-nemo-fileroller-5.6.1/${PN}"

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

COMMIT="f65321736475429316f07ee94ec0deac8e46ec4a"
DESCRIPTION="Set of tools to manage bluetooth devices for Linux"
HOMEPAGE="https://github.com/khvzak/bluez-tools"
SRC_URI="https://github.com/khvzak/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-libs/glib:2
	net-wireless/bluez[obex]
	sys-libs/readline:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

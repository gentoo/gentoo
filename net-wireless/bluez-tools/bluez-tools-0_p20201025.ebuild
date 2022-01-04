# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A set of tools to manage bluetooth devices for linux"
HOMEPAGE="https://github.com/khvzak/bluez-tools"
COMMIT="f65321736475429316f07ee94ec0deac8e46ec4a"
SRC_URI="https://github.com/khvzak/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	net-wireless/bluez[obex]
	sys-libs/readline:0"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README )

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	eautoreconf
}

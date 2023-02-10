# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

DESCRIPTION="A minimalistic GKrellM2 plugin to control radio tuners"
HOMEPAGE="http://gkrellm.luon.net/gkrellm-radio.php"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="lirc"

RDEPEND="
	app-admin/gkrellm:2[X]
	lirc? ( app-misc/lirc )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-r1-pkgconfig.patch
	"${FILESDIR}"/${P}-Use-standard-int-types.patch
)

src_configure() {
	PLUGIN_SO=( radio$(get_modname) )
	default
}

src_compile() {
	use lirc && myconf="${myconf} WITH_LIRC=1"
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" ${myconf}
}

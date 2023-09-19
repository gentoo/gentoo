# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

MY_P="${P/gkrellm/gkrellm2}"

DESCRIPTION="A Gkrellm2 plugin for displaying and manipulating CPU frequency"
HOMEPAGE="https://github.com/sainsaar/gkrellm2-cpupower"
SRC_URI="https://github.com/sainsaar/gkrellm2-cpupower/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-admin/gkrellm:2[X]"
RDEPEND="
	${DEPEND}
	app-admin/sudo
	sys-power/cpupower
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	local PLUGIN_SO=( cpupower$(get_modname) )
	gkrellm-plugin_src_install
	emake CC="$(tc-getCC)" DESTDIR="${D}" install-sudo
}

pkg_postinst() {
	einfo
	einfo "For changing the governor and CPU frequencies as a user, create the \"trusted\""
	einfo "group, and add those users to that group who should be allowed to perform"
	einfo "these changes."
	einfo
}

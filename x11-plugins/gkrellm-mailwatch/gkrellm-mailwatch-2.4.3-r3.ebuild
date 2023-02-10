# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

DESCRIPTION="A GKrellM2 plugin that shows the status of additional mail boxes"
HOMEPAGE="http://gkrellm.luon.net/mailwatch.php"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/2.4.3-0001-Respect-LDFLAGS.patch
	"${FILESDIR}"/2.4.3-0002-Use-gkrellm_gkd_string_width.patch
	"${FILESDIR}"/2.4.3-0003-Remove-a-few-more-GCC-warnings.patch
	"${FILESDIR}"/2.4.3-0004-Do-not-force-O2-in-CFLAGS.patch
	"${FILESDIR}/${P}"-pkgconfig.patch
)

src_configure() {
	tc-export CC PKG_CONFIG

	PLUGIN_SO=( mailwatch$(get_modname) )

	default
}

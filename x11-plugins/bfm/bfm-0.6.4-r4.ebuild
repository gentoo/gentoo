# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Dockapp and gkrellm plug-in combining timecop's bubblemon and wmfishtime"
HOMEPAGE="https://github.com/JNRowe/bfm"
SRC_URI="https://github.com/JNRowe/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="gkrellm"

RDEPEND="
	gkrellm? ( >=app-admin/gkrellm-2[X] )
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_compile() {
	emake CC="$(tc-getCC)" GENTOO_LDFLAGS="${LDFLAGS}"
	use gkrellm && emake gkrellm CC="$(tc-getCC)"
}

src_install() {
	dobin bubblefishymon

	doman doc/*.1
	dodoc ChangeLog* README* doc/*.sample

	if use gkrellm; then
		insinto /usr/$(get_libdir)/gkrellm2/plugins
		doins gkrellm-bfm.so
	fi
}

# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Linux kernel trace file system library"
HOMEPAGE="https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/"

if [[ ${PV} =~ [9]{4,} ]]; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

# Please double check the minimum libtraceevent version!
RDEPEND="
	!<dev-util/trace-cmd-3.1.4-r2
	>=dev-libs/libtraceevent-1.7.0
"
DEPEND="${RDEPEND}"
# source-highlight is needed, see bug https://bugs.gentoo.org/865469
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	dev-util/source-highlight
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dasciidoctor=false
	)

	# TODO: get docs & tests optional upstream
	meson_src_configure
}

src_install() {
	meson_src_install

	find "${ED}" -type f -name '*.a' -delete || die
}

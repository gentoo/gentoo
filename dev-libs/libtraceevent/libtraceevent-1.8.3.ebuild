# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Linux kernel trace event library"
HOMEPAGE="https://www.trace-cmd.org/"

if [[ ${PV} =~ [9]{4,} ]]; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/snapshot/${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~loong ppc ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-util/trace-cmd-3.0
"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	test? ( dev-util/cunit )
"

src_configure() {
	local emesonargs=(
		-Dasciidoctor=false
		-Ddoc=$(usex doc true false)
	)

	# TODO: get docs & tests optional upstream
	meson_src_configure
}

src_install() {
	# TODO: get docs & tests optional upstream
	meson_src_install

	find "${ED}" -type f -name '*.a' -delete || die
}

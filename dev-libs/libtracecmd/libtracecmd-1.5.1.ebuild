# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Linux kernel tracecmd library"
HOMEPAGE="https://www.trace-cmd.org/"

if [[ ${PV} =~ [9]{4,} ]]; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-${P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND="
	!<dev-util/trace-cmd-3.2
	dev-libs/libtraceevent
	dev-libs/libtracefs
"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
"
BDEPEND="app-text/asciidoc"

S="${WORKDIR}/trace-cmd-${P}/lib"

src_configure() {
	local emesonargs=(
		-Dasciidoctor=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	find "${ED}" -type f -name '*.a' -delete || die
}

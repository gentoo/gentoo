# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scripts to convert regular ASCII text to man pages"
HOMEPAGE="https://github.com/mvertes/txt2man"
SRC_URI="https://github.com/mvertes/txt2man/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND="app-shells/bash
	sys-apps/gawk"

S="${WORKDIR}/${PN}-${P}"

DOCS=( Changelog README )

src_install() {
	emake prefix="${ED}/usr" install
	einstalldocs
}

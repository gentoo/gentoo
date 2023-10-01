# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Generate a file list suitable for full or incremental backups"
HOMEPAGE="https://github.com/miekg/rdup/releases"
SRC_URI="https://github.com/miekg/rdup/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"
# It's known to fail with USE=debug
REQUIRED_USE="test? ( !debug )"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/libarchive
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/nettle
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-util/dejagnu )"

src_prepare() {
	default
	sed -i -e 's/ -Werror//' GNUmakefile.in || die "Failed to fix Makefile"
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

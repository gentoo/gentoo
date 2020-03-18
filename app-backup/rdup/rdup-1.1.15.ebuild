# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Generate a file list suitable for full or incremental backups"
HOMEPAGE="https://github.com/miekg/rdup/releases"
SRC_URI="https://github.com/miekg/rdup/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/libarchive
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/nettle"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

src_prepare() {
	default_src_prepare
	sed -i -e 's/ -Werror//' GNUmakefile.in || die "Failed to fix Makefile"
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_test() {
	if use debug; then
		ewarn "Test phase skipped, as it is known to fail with USE=\"debug\"."
	else
		default_src_test
	fi
}

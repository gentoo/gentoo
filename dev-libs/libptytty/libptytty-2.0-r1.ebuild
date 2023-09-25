# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library for mostly OS-independent handling of pty/tty/utmp/wtmp/lastlog"
HOMEPAGE="http://software.schmorp.de/pkg/libptytty.html"
SRC_URI="http://dist.schmorp.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-rundir.patch
	"${FILESDIR}"/${PN}-2.0-configure-clang16.patch
)

DOCS=( Changes README )

src_configure() {
	# Bug #828923
	local mycmakeargs=()
	if use elibc_musl; then
		mycmakeargs+=(
			-DPT_LASTLOGX_FILE="\"/dev/null/lastlogx\""
			-DPT_WTMPX_FILE="\"/dev/null/wtmpx\""
		)
	fi

	cmake_src_configure
}

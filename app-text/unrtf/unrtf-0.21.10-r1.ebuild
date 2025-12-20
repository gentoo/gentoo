# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Converts RTF files to various formats"
HOMEPAGE="https://www.gnu.org/software/unrtf/unrtf.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"

PATCHES=(
	"${FILESDIR}"/${PN}-0.21.10-use-_GNU_SOURCE.patch
)

src_configure() {
	append-flags -std=gnu17

	econf
}

# Copyright 2014-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoo-functions.git"
else
	SRC_URI="https://gitweb.gentoo.org/proj/gentoo-functions.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

inherit meson

DESCRIPTION="Base functions required by all Gentoo systems"
HOMEPAGE="https://gitweb.gentoo.org/proj/gentoo-functions.git"

LICENSE="GPL-2 public-domain"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# Specifically needs GNU find, as well.
RDEPEND=">=sys-apps/findutils-4.9"

src_configure() {
	local emesonargs=(
		# Deliberately avoid /usr as consumers assume we're at /lib/gentoo.
		--prefix="${EPREFIX:-/}"
		--mandir="${EPREFIX}/usr/share/man"
		$(meson_use test tests)
	)

	meson_src_configure
}

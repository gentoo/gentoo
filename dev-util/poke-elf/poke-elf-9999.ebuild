# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A GNU poke pickle for manipulating ELF files"
HOMEPAGE="https://jemarch.net/poke-elf"

if [[ ${PV} == 9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/poke/poke-elf.git"
	REGEN_BDEPEND="
		>=dev-build/autoconf-2.62
		>=dev-build/automake-1.16
		>=dev-util/poke-4
		sys-apps/texinfo
	"
elif [[ $(ver_cut 2) -ge 90 || $(ver_cut 3) -ge 90 ]]; then
	SRC_URI="https://alpha.gnu.org/gnu/poke/${P}.tar.gz"
	REGEN_BDEPEND=""
else
	SRC_URI="mirror://gnu/poke/${P}.tar.gz"
	KEYWORDS="~amd64"
	REGEN_BDEPEND=""
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=dev-util/poke-4
	!<dev-util/poke-4
"
DEPEND="${RDEPEND}"
BDEPEND="${REGEN_BDEPEND}"

src_prepare() {
	default

	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	fi
}

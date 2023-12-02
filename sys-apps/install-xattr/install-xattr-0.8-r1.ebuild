# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wrapper to coreutils install to preserve Filesystem Extended Attributes"
HOMEPAGE="https://dev.gentoo.org/~blueness/install-xattr/"

inherit flag-o-matic toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/elfix.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/install-xattr/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
	S="${WORKDIR}"/${PN}
fi

LICENSE="GPL-3"
SLOT="0"

PATCHES=(
	# Backports from master, drop on next release
	"${FILESDIR}"/${PV}
)

src_prepare() {
	default

	tc-export CC
	append-lfs-flags
}

src_compile() {
	if [[ ${PV} == "9999" ]] ; then
		cd "${WORKDIR}/${P}/misc/${PN}" || die
	fi
	default
}

src_install() {
	if [[ ${PV} == "9999" ]] ; then
		cd "${WORKDIR}/${P}/misc/${PN}" || die
	fi

	emake DESTDIR="${ED}" install
}

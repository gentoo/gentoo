# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools
if [[ ${PV} == "99999999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"
	KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="Eselect module for management of multiple Rust versions"
HOMEPAGE="https://gitweb.gentoo.org/proj/eselect-rust.git"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	if has_version 'dev-lang/rust' || has_version 'dev-lang/rust-bin'; then
		eselect rust update --if-unset
	fi
}

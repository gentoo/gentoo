# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

if [[ ${PV} == "99999999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
else
	SRC_URI="https://dev.gentoo.org/~whissi/dist/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Eselect module for management of multiple Rust versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Rust"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

src_prepare() {
	default
	[[ ${PV} == "99999999" ]] && eautoreconf
}

pkg_postinst() {
	if has_version 'dev-lang/rust' || has_version 'dev-lang/rust-bin'; then
		eselect rust update --if-unset
	fi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic

DESCRIPTION="Static code analysis of refpolicy style SELinux policy"
HOMEPAGE="https://github.com/TresysTechnology/selint/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/TresysTechnology/selint.git"
else
	SRC_URI="https://github.com/TresysTechnology/selint/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/confuse:=
	dev-libs/uthash
	elibc_musl? ( sys-libs/fts-standalone )"

DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

src_prepare() {
	[[ ${PV} == 9999 ]] && eautoreconf

	eapply_user
}

src_configure() {
	use elibc_musl && append-libs "-lfts"

	econf $(use_with test check)
}

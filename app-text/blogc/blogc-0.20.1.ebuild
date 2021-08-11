# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A blog compiler"
HOMEPAGE="https://blogc.rgm.io/"
if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/blogc/blogc.git"
	inherit git-r3 autotools
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
fi

if [[ ${PV} = *9999* ]]; then
	BDEPEND="app-text/ronn"
else
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="git httpd make test"
RESTRICT="!test? ( test )"

RDEPEND="git? ( dev-vcs/git )"
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig
	test? (
		git? ( dev-vcs/git )
	)"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	eapply_user
	default
}

src_configure() {
	local myconf=""

	if [[ ${PV} = *9999* ]]; then
		myconf+="--enable-ronn"
	else
		myconf+="--disable-ronn"
	fi

	econf \
		$(use_enable test tests) \
		$(use_enable git git-receiver) \
		$(use_enable make make) \
		$(use_enable httpd runserver) \
		--disable-make-embedded \
		--disable-valgrind \
		${myconf}
}

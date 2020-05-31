# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/blogc/blogc.git"
	inherit git-r3 autotools
fi

DESCRIPTION="A blog compiler"
HOMEPAGE="https://blogc.rgm.io/"

SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
	DEPEND="app-text/ronn"
fi

LICENSE="BSD"
SLOT="0"
IUSE="git httpd make test"
RESTRICT="!test? ( test )"

RDEPEND="
	git? (
		dev-vcs/git )
	!dev-vcs/blogc-git-receiver
	!www-servers/blogc-runserver"

DEPEND="${DEPEND}
	virtual/pkgconfig
	test? (
		git? ( dev-vcs/git )
		dev-util/cmocka )"

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

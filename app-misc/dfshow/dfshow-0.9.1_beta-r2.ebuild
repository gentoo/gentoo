# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 flag-o-matic

MY_PV="${PV//_beta/-beta}"
DESCRIPTION="DF-SHOW is a Unix-like rewrite of some of the applications from DF-EDIT"
HOMEPAGE="https://github.com/roberthawdon/dfshow"
SRC_URI="https://github.com/roberthawdon/dfshow/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libconfig:=
	sys-libs/ncurses:0=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1_beta-use-PKG_CHECK_MODULES-for-ncurses-libconfig.patch
)

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Standard on macOS
		# No real motivation to push libtool upstream just for this
		append-ldflags -Wl,-undefined -Wl,dynamic_lookup
	fi

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/854726
	# https://github.com/roberthawdon/dfshow/issues/172
	filter-lto

	default
}

src_install() {
	default

	newbashcomp "${S}/misc/auto-completion/bash/sf-completion.bash" sf-completion
	newbashcomp "${S}/misc/auto-completion/bash/show-completion.bash" show-completion

	insinto /usr/share/zsh/site-functions
	doins "${S}/misc/auto-completion/zsh/_sf"
	doins "${S}/misc/auto-completion/zsh/_show"
}

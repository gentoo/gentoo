# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Run commands as super user or another user, alternative to sudo from OpenBSD"

MY_PN=OpenDoas
MY_P=${MY_PN}-${PV}
HOMEPAGE="https://github.com/Duncaen/OpenDoas"
SRC_URI="https://github.com/Duncaen/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm"
IUSE="pam"

RDEPEND="pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}
	virtual/yacc"

src_prepare()
{
	default
	sed -i 's/-Werror //' Makefile || die
}

src_configure()
{
	tc-export CC AR
	./configure \
		--prefix="${EPREFIX}"/usr \
		--sysconfdir="${EPREFIX}"/etc \
		$(use_with pam) \
		|| die
}

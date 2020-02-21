# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-mod/s}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Quotes from Prolinux articles and comments"
HOMEPAGE="https://github.com/Nanolx/fortunes-flashrider"
SRC_URI="https://github.com/Nanolx/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

RDEPEND="games-misc/fortune-mod"

src_prepare()
{
	sed -e 's#INSTALLDIR = .*#INSTALLDIR = /share/fortune#' -i Makefile
	eapply_user
}

src_install() {
	emake install PREFIX="${EPREFIX}"/usr DESTDIR="${D}"
	dodoc AUTHORS ChangeLog README
}

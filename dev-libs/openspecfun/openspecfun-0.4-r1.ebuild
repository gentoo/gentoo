# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openspecfun/openspecfun-0.4-r1.ebuild,v 1.3 2015/06/07 09:04:58 jlec Exp $

EAPI=5

inherit fortran-2 multilib

DESCRIPTION="A collection of special mathematical functions"
HOMEPAGE="http://julialang.org/"
SRC_URI="https://github.com/JuliaLang/openspecfun/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	sed -i "s:/lib:/$(get_libdir):" Make.inc || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install
}

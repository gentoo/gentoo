# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Fast SSL configuration scanner"
HOMEPAGE="https://github.com/rbsec/sslscan"
MY_FORK="rbsec"
SRC_URI="https://github.com/${MY_FORK}/${PN}/archive/${PV}-${MY_FORK}.tar.gz -> ${P}-${MY_FORK}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

# Depend on -bindist since sslscan unconditionally requires elliptic
# curve support, bug 491102
DEPEND="!libressl? ( dev-libs/openssl:0[-bindist] ) libressl? ( dev-libs/libressl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-${MY_FORK}"
src_install() {
	DESTDIR="${D}" emake install

	dodoc Changelog README.md
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca-logger/qca-logger-2.0.0_beta2.ebuild,v 1.13 2015/02/22 07:43:46 jer Exp $

EAPI="2"
inherit eutils qt4-r2

MY_P="${P/_/-}"
QCA_VER="${PV%.*}"

DESCRIPTION="Logger plugin for QCA"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/qca/${QCA_VER}/plugins/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 hppa ~ia64 ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

DEPEND=">=app-crypt/qca-${QCA_VER}[debug?]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	# cannot use econf because of non-standard configure script
	./configure	--qtdir=/usr --no-separate-debug-info \
		$(use debug && echo "--debug" || echo "--release") || die

	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die
	dodoc README || die
}

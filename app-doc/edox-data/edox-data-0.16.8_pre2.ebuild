# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/edox-data/edox-data-0.16.8_pre2.ebuild,v 1.1 2006/10/22 05:40:11 vapier Exp $

inherit eutils

EVER="${PV/_pre*}"
EDOXVER="${EVER}-0.0${PV/*_pre}"
DESCRIPTION="The Enlightenment online help"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/e16-docs-${EDOXVER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=x11-wm/enlightenment-0.16.8"

S=${WORKDIR}/e16-docs-${EDOXVER}

src_compile() {
	econf --enable-fsstd || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}

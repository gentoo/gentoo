# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/magneto-core/magneto-core-254.ebuild,v 1.1 2013/12/18 05:08:18 lxnay Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 multilib

DESCRIPTION="Entropy Package Manager notification applet library"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/magneto"

DEPEND="~sys-apps/rigo-daemon-${PV}[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/lib" magneto-core-install || die "make install failed"
	python_optimize "${D}/usr/$(get_libdir)/entropy/magneto"
}

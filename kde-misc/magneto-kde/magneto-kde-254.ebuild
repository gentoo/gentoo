# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/magneto-kde/magneto-kde-254.ebuild,v 1.1 2013/12/18 05:09:19 lxnay Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Entropy Package Manager notification applet KDE frontend"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/magneto"

DEPEND="${PYTHON_DEPS}"
RDEPEND="~app-misc/magneto-loader-${PV}[${PYTHON_USEDEP}]
	kde-base/pykde4
	dev-python/PyQt4[dbus]
	${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/lib" magneto-kde-install || die "make install failed"
	python_optimize "${D}/usr/lib/entropy/magneto/magneto/kde"
}

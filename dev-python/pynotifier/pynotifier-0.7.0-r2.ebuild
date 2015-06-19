# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pynotifier/pynotifier-0.7.0-r2.ebuild,v 1.8 2015/04/08 08:05:21 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="pyNotifier provides an implementation of a notifier/event scheduler"
HOMEPAGE="http://www.bitkipper.net/"
SRC_URI="http://www.bitkipper.net/bytes/debian/dists/unstable/source/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="qt4 gtk"

DEPEND=""
RDEPEND="dev-python/twisted-core
	gtk? ( dev-python/pygobject:2[${PYTHON_USEDEP}] )
	qt4? ( dev-python/PyQt4[X,${PYTHON_USEDEP}] )"

python_prepare_all() {
	use gtk || rm notifier/nf_gtk.py
	use qt4 || rm notifier/nf_qt.py
	distutils-r1_python_prepare_all
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="pyNotifier provides an implementation of a notifier/event scheduler"
HOMEPAGE="http://www.bitkipper.net/"
SRC_URI="http://www.bitkipper.net/bytes/debian/dists/unstable/source/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gtk"

DEPEND=""
RDEPEND="
	|| (
		dev-python/twisted[${PYTHON_USEDEP}]
		dev-python/twisted-core[${PYTHON_USEDEP}]
	)
	gtk? ( dev-python/pygobject:2[${PYTHON_USEDEP}] )"

python_prepare_all() {
	if !use gtk; then
		rm notifier/nf_gtk.py || die
	fi
	rm notifier/nf_qt.py || die
	distutils-r1_python_prepare_all
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/qt-recordmydesktop/qt-recordmydesktop-0.3.8-r2.ebuild,v 1.4 2012/05/21 20:21:45 ago Exp $

EAPI=4

PYTHON_DEPEND="2:2.6"
RESTRICT_PYTHON_ABIS="3.*"
inherit autotools base eutils python

DESCRIPTION="Qt4 interface for RecordMyDesktop"
HOMEPAGE="http://recordmydesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/recordmydesktop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Test is buggy : bug #186752
# Tries to run intl-toolupdate without it being substituted from
# configure, make test tries run make check in flumotion/test what
# makes me think that this file has been copied from flumotion without
# much care...
RESTRICT="test"

RDEPEND=">=media-video/recordmydesktop-0.3.8
	x11-apps/xwininfo"
DEPEND="${RDEPEND}
	>=dev-python/PyQt4-4.1[X]"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}/${P}-check-for-jack.patch"
	"${FILESDIR}/${P}-desktopfile.patch"
	"${FILESDIR}/${P}-pyqt4.patch"
)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	base_src_prepare
	eautoreconf

	# these deps are required by PyQt4, not this package
	sed -e '/^PKG_CHECK_MODULES/d' -i configure.ac || die "sed failed"
	eautoreconf

	python_convert_shebangs 2 src/qt-recordMyDesktop.in

	sed -e 's/@ALL_LINGUAS@//' -i po/Makefile.in.in \
		|| die "respect linguas sed failed"
	strip-linguas -i po
	echo ${LINGUAS} | tr ' ' '\n' > po/LINGUAS
}

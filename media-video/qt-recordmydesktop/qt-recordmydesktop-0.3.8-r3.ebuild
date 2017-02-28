# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit autotools python-single-r1

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

RDEPEND="
	>=dev-python/PyQt4-4.1[X,${PYTHON_USEDEP}]
	>=media-video/recordmydesktop-0.3.8
	x11-apps/xwininfo
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}/${P}-check-for-jack.patch"
	"${FILESDIR}/${P}-desktopfile.patch"
	"${FILESDIR}/${P}-pyqt4.patch"
)

src_prepare() {
	default

	# these deps are required by PyQt4, not this package
	sed -e '/^PKG_CHECK_MODULES/d' -i configure.ac || die "sed failed"
	eautoreconf

	python_fix_shebang src/qt-recordMyDesktop.in
}

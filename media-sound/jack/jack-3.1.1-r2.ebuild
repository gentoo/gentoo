# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A frontend for several cd-rippers and mp3 encoders"
HOMEPAGE="http://www.home.unix-ag.org/arne/jack/"
SRC_URI="http://www.home.unix-ag.org/arne/jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-python/cddb-py[${PYTHON_USEDEP}]
	dev-python/id3-py[${PYTHON_USEDEP}]
	dev-python/pyid3lib[${PYTHON_USEDEP}]
	dev-python/pyvorbis[${PYTHON_USEDEP}]
	media-libs/flac
	media-sound/lame
	media-sound/cdparanoia"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.1-python26.patch"
	"${FILESDIR}/${PN}-3.1.1-setup-and-cursesmodule.patch"
	"${FILESDIR}/${PN}-3.1.1-add-cddbserver-musicbrainz.patch"
)

python_install_all() {
	insinto /etc
	newins example.etc.jackrc jackrc

	newman jack.man jack.1

	local DOCS=( README doc/ChangeLog doc/TODO )
	local HTML_DOCS=( doc/*.{html,css,gif} )
	distutils-r1_python_install_all
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=yes

inherit distutils-r1

MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="File system that arranges media files based their tags"
HOMEPAGE="https://launchpad.net/pytagsfs"
SRC_URI="http://www.alittletooquiet.net/media/release/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S="${WORKDIR}/${MY_P}"

RDEPEND=">=dev-python/fuse-python-0.2-r1
	>=dev-python/sclapp-0.5.2
	|| ( dev-python/inotifyx
		( dev-libs/libgamin[python]
			app-admin/gam-server ) )
	media-libs/mutagen"
DEPEND="${RDEPEND}
	dev-libs/libxml2[python]
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	test? ( dev-python/inotifyx
		dev-libs/libgamin[python]
		app-admin/gam-server
		media-sound/madplay
		media-sound/vorbis-tools
		media-libs/flac )"

python_test() {
	${PYTHON} setup.py test || die
}

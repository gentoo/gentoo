# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/pytagsfs/pytagsfs-0.9.2.ebuild,v 1.5 2014/09/18 16:16:24 sping Exp $

EAPI="2"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython 2.7-pypy-*"
DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

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
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	test? ( dev-python/inotifyx
		dev-libs/libgamin[python]
		app-admin/gam-server
		media-sound/madplay
		media-sound/vorbis-tools
		media-libs/flac )"

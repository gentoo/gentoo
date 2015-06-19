# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/radiotray/radiotray-9999.ebuild,v 1.11 2015/04/08 18:14:38 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

DISTUTILS_NO_PARALLEL_BUILD=1

inherit distutils-r1 mercurial

DESCRIPTION="Online radio streaming player"
HOMEPAGE="http://radiotray.sourceforge.net/"
SRC_URI=""
EHG_REPO_URI="http://radiotray.hg.sourceforge.net:8000/hgroot/radiotray/radiotray"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS=""
IUSE=""

LANGS="ca de el en_GB es fi fr gl gu hu it ko lt pl pt_BR pt ro ru sk sl sv te
tr uk zh_CN"

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

RDEPEND="sys-apps/dbus[X]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-ugly:0.10
	media-plugins/gst-plugins-alsa:0.10
	media-plugins/gst-plugins-libmms:0.10
	media-plugins/gst-plugins-ffmpeg:0.10
	media-plugins/gst-plugins-mad:0.10
	media-plugins/gst-plugins-ogg:0.10
	media-plugins/gst-plugins-soup:0.10
	media-plugins/gst-plugins-vorbis:0.10"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS CONTRIBUTORS NEWS README )

python_prepare_all() {
	# remove LINUGAS file so we can create our
	rm "${S}"/po/LINGUAS
	for x in ${LANGS}; do
		use "linguas_${x}" && echo "${x}" >> "${S}"/po/LINGUAS
		! use "linguas_${x}" && rm "${S}"/po/${x}.po
	done

	distutils-r1_python_prepare_all
}

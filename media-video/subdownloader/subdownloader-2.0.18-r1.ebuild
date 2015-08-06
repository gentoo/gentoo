# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subdownloader/subdownloader-2.0.18-r1.ebuild,v 1.2 2015/08/06 09:59:22 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 eutils

DESCRIPTION="GUI application for automatic downloading/uploading of subtitles for videofiles"
HOMEPAGE="http://www.subdownloader.net/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_2.0.18.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/PyQt4[${PYTHON_USEDEP}]
	dev-python/kaa-metadata[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	python_fix_shebang "${S}"/run.py
	insinto /usr/share/"${PN}"
	doins -r cli FileManagement gui languages locale modules run.py
	fperms 755 /usr/share/"${PN}"/run.py
	dosym /usr/share/"${PN}"/run.py /usr/bin/"${PN}"
	doman subdownloader.1
	dodoc README ChangeLog
	doicon gui/images/subdownloader.png
	domenu subdownloader.desktop
}

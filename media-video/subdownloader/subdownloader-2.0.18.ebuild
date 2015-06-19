# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subdownloader/subdownloader-2.0.18.ebuild,v 1.4 2013/06/25 12:54:33 ago Exp $

EAPI=5

PYTHON_DEPEND="2"

inherit python eutils

DESCRIPTION="GUI application for automatic downloading/uploading of subtitles for videofiles"
HOMEPAGE="http://www.subdownloader.net/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_2.0.18.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
#S="${WORKDIR}/subdownloader-${PV}"

DEPEND="
	dev-python/PyQt4
	dev-python/kaa-metadata"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs 2 "${S}"/run.py
}

src_install() {
	insinto /usr/share/"${PN}"
	doins -r cli FileManagement gui languages locale modules run.py
	fperms 755 /usr/share/"${PN}"/run.py
	dosym /usr/share/"${PN}"/run.py /usr/bin/"${PN}"
	doman subdownloader.1
	dodoc README ChangeLog
	doicon gui/images/subdownloader.png
	domenu subdownloader.desktop
}

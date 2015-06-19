# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qt-docs/qt-docs-5.4.2_p0.ebuild,v 1.1 2015/06/17 13:46:28 pesa Exp $

EAPI=5

inherit versionator

MY_PV=$(get_version_component_range 1)$(get_version_component_range 2)

DESCRIPTION="Documentation for Qt5, for use with Qt Creator and other tools"
HOMEPAGE="https://www.qt.io/"
SRC_URI="http://download.qt.io/online/qtsdkrepository/linux_x64/desktop/qt5_${MY_PV}_src_doc_examples/qt.${MY_PV}.doc/${PV/_p/-}qt5_docs.7z"

LICENSE="FDL-1.3"
SLOT="5"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/p7zip"

S=${WORKDIR}/Docs/Qt-$(get_version_component_range 1-2)

src_install() {
	# remove global docs that conflict with qtcore
	rm -rf global

	# ${PV} instead of ${PF} is intentional
	local dest=/usr/share/doc/qt-${PV%%_p*}
	insinto "${dest}"
	doins -r *
	docompress -x "${dest}"
}

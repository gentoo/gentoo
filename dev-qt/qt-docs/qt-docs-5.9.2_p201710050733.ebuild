# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

MY_PV=$(get_version_component_range 1)$(get_version_component_range 2)$(get_version_component_range 3)
MY_REV=0$(get_version_component_range 4)
MY_P=$(get_version_component_range 1-3)-${MY_REV/p/-}qt-everywhere-documentation

DESCRIPTION="Documentation for Qt5, for use with Qt Creator and other tools"
HOMEPAGE="https://www.qt.io/"
SRC_URI="https://download.qt.io/online/qtsdkrepository/linux_x64/desktop/qt5_${MY_PV}_src_doc_examples/qt.${MY_PV}.doc/${MY_P}.7z"

LICENSE="FDL-1.3"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="app-arch/p7zip"

S=${WORKDIR}/Docs/Qt-$(get_version_component_range 1-3)

src_prepare() {
	default

	# bug 597026
	rm -r global || die

	# bug 602750
	rm Makefile || die
}

src_install() {
	# ${PV} instead of ${PF} is intentional
	local dest=/usr/share/doc/qt-${PV%%_p*}
	insinto "${dest}"
	doins -r *
	docompress -x "${dest}"
}

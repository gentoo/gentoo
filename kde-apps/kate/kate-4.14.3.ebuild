# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kate/kate-4.14.3.ebuild,v 1.1 2015/06/04 18:44:49 kensington Exp $

EAPI=5
KDE_HANDBOOK="optional"
KMNAME="kate"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit python-single-r1 kde4-meta

DESCRIPTION="Kate is an MDI texteditor"
HOMEPAGE="http://www.kde.org/applications/utilities/kate http://kate-editor.org"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	$(add_kdebase_dep kactivities '' 4.13)
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/qjson
	python? (
		${PYTHON_DEPS}
		$(add_kdebase_dep pykde4 "${PYTHON_USEDEP}" 4.9.2-r1)
	)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep katepart)
"

KMEXTRA="
	addons/kate
	addons/plasma
"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
	kde4-meta_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build python pate)
	)

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kaddressbook:${SLOT}; then
		echo
		elog "File templates plugin requires kde-base/kaddressbook:${SLOT}."
		elog "Please install it if you plan to use this plugin."
		echo
	fi
}

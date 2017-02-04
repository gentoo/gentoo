# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_AUTODEPS="false"
KDE_TEST="forceoptional-recursive"
inherit kde5 xdg-utils

if [[ ${KDE_BUILD_TYPE} = live ]]; then
	EGIT_REPO_URI="https://github.com/ximion/${PN}"
else
	inherit versionator
	MY_PV="$(replace_all_version_separators '_')"
	MY_P="APPSTREAM_${MY_PV}"
	SRC_URI="https://github.com/ximion/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${PN}-${MY_P}"
fi

DESCRIPTION="Cross-distro effort for providing metadata for software in the Linux ecosystem"
HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"

LICENSE="LGPL-2.1+ GPL-2+"
# check APPSTREAM_LIB_API_LEVEL
SLOT="0/4"
IUSE="apt doc qt5"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-libs/libyaml
	dev-libs/snowball-stemmer
	qt5? ( dev-qt/qtcore:5 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	dev-util/itstool
	sys-devel/gettext
	test? (
		qt5? ( dev-qt/qttest:5 )
	)
"

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DSTEMMING=ON
		-DL18N=ON
		-DVAPI=OFF
		-DMAINTAINER=OFF
		-DSANITIZERS=OFF
		-DDOCUMENTATION=OFF
		-DAPT_SUPPORT=$(usex apt)
		-DINSTALL_PREBUILT_DOCS=$(usex doc)
		-DQT=$(usex qt5)
	)

	kde5_src_configure
}

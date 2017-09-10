# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg-utils

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ximion/${PN}"
else
	inherit versionator
	MY_PV="$(replace_all_version_separators '_')"
	MY_P="APPSTREAM_${MY_PV}"
	SRC_URI="https://github.com/ximion/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_P}"
fi

DESCRIPTION="Cross-distro effort for providing metadata for software in the Linux ecosystem"
HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"

LICENSE="LGPL-2.1+ GPL-2+"
# check as_api_level
SLOT="0/4"
IUSE="apt doc qt5 test"

RDEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection
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

	local emesonargs=(
		-Denable-docs=false
		-Denable-maintainer=false
		-Denable-stemming=true
		-Denable-vapi=false
		-Denable-apt-support=$(usex apt true false)
		-Denable-apidocs=$(usex doc true false)
		-Denable-qt=$(usex qt5 true false)
	)

	meson_src_configure
}

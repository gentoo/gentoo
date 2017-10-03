# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

inherit eutils versionator

DESCRIPTION="JavaScript IDE for client- and server-side development with Node.js"
HOMEPAGE="http://www.jetbrains.com/webstorm"
SRC_URI="http://download.jetbrains.com/${PN}/WebStorm-$(get_version_component_range 1-3).tar.gz"

LICENSE="WebStorm WebStorm_Academic WebStorm_Classroom WebStorm_OpenSource WebStorm_personal"
SLOT="$(get_major_version)"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jdk-1.7"

S="${WORKDIR}/WebStorm-$(get_version_component_range 4-6)"

src_install() {
	insinto "/opt/${PN}"
	doins -r .
	fperms 755 /opt/${PN}/bin/{${PN}.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "/opt/${PN}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "${PN}" "${PN}" "Development;IDE;"
}

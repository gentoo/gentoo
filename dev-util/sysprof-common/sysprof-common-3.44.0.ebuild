# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="sysprof"

inherit gnome.org

DESCRIPTION="Static library for sysprof capture data generation"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	!=dev-util/sysprof-3.34.1-r0
	!=dev-util/sysprof-capture-3.36.0-r0
"

src_install() {
	insinto /usr/share/dbus-1/interfaces/
	doins "${S}"/src/org.gnome.Sysprof3.Profiler.xml
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="displays the status of your laptop battery"
HOMEPAGE="http://www.nongnu.org/gap/batmon/index.html"
# upstream in a weird state where this tag was never released but debian packaged it
SRC_URI="
	mirror://debian/pool/main/b/batmon.app/batmon.app_${PV}.orig.tar.gz
	mirror://debian/pool/main/b/batmon.app/batmon.app_${PV}-4.debian.tar.xz
"
S="${WORKDIR}/batmon.app-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	gnustep-base/gnustep-base:=
	gnustep-base/gnustep-gui
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}"/debian/patches/
)

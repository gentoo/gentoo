# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Fred78290/nct6687d"
else
	COMMIT="5997c92b41081bfb870a9b6167b7e96e3efdd50f"
	SRC_URI="https://github.com/Fred78290/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Kernel module for the Nuvoton NCT6687-R"
HOMEPAGE="https://github.com/Fred78290/nct6687d"

LICENSE="GPL-2"
SLOT="0"

src_compile() {
	local modlist=( nct6687=kernel/drivers/hwmon:::build )
	local modargs=( KVER="${KV_FULL}" KDIR="${KV_OUT_DIR}" )
	linux-mod-r1_src_compile
}

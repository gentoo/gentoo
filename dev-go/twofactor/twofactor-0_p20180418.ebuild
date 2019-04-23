# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/gokyle/twofactor

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT=bbc82ff8de72400ce39a13077627531d9841ad62
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Two-factor authentication library for Go"
HOMEPAGE="https://github.com/gokyle/twofactor"
LICENSE="MIT"
SLOT="0/${PVR}"
RDEPEND=""
DEPEND="${RDEPEND}
	dev-go/qr:="

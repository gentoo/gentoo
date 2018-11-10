# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=rsc.io/qr

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT=48b2ede4844e13f1a2b7ce4d2529c9af7e359fc5
	SRC_URI="https://github.com/rsc/qr/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Basic QR code library for Go"
HOMEPAGE="https://github.com/rsc/qr"
LICENSE="MIT"
SLOT="0/${PVR}"
RDEPEND=""

src_install() {
	golang-build_src_install

	pushd "src/${EGO_PN}" >/dev/null || die
	einstalldocs
	popd >/dev/null || die
}

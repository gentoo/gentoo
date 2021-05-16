# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/kylelemons/godebug/pretty

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT=d65d576e9348f5982d7f6d83682b694e731a45c6
	SRC_URI="https://github.com/kylelemons/godebug/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Pretty printing for Go"
HOMEPAGE="https://github.com/kylelemons/godebug"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
RDEPEND=""

src_unpack() {
	EGO_PN="github.com/kylelemons/godebug" golang-vcs-snapshot_src_unpack
}

src_install() {
	golang-build_src_install

	pushd "src/${EGO_PN}" >/dev/null || die
	einstalldocs
	popd >/dev/null || die
}

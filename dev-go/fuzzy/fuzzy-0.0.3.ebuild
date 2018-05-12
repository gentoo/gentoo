# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/sahilm/fuzzy

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go library that provides fuzzy string matching"
HOMEPAGE="https://github.com/sahilm/fuzzy"
LICENSE="MIT"
SLOT="0/${PVR}"
IUSE="test"

DEPEND="test? ( dev-go/godebug-pretty )"
RDEPEND=""

src_install() {
	golang-build_src_install

	pushd "src/${EGO_PN}" >/dev/null || die
	einstalldocs
	popd >/dev/null || die
}

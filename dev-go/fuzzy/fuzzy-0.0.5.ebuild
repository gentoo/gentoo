# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/sahilm/fuzzy

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Go library that provides fuzzy string matching"
HOMEPAGE="https://github.com/sahilm/fuzzy"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PVR}"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( dev-go/godebug-pretty )"

src_install() {
	golang-build_src_install

	pushd "src/${EGO_PN}" >/dev/null || die
	einstalldocs
	popd >/dev/null || die
}

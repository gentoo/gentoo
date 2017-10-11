# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build

EGO_PN="github.com/ncw/${PN}"

if [[ ${PV} == *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="A program to sync files to and from various cloud storage providers"
HOMEPAGE="https://rclone.org/"

LICENSE="MIT"
SLOT="0"

src_install() {
	dobin ${PN}
	doman src/${EGO_PN}/${PN}.1
	dodoc src/${EGO_PN}/README.md
}

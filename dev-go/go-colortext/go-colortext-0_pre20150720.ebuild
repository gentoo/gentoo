# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/daviddengcn/go-colortext"
EGIT_COMMIT=3b18c85
ARCHIVE_URI="https://github.com/daviddengcn/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit golang-build golang-vcs-snapshot

DESCRIPTION="Change the console foreground and background colors"
HOMEPAGE="https://github.com/daviddengcn/go-colortext"
SRC_URI="${ARCHIVE_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	golang-build_src_install
	dodoc src/${EGO_PN}/*.md
}

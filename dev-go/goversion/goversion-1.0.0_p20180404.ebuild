# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="rsc.io/goversion"

EGIT_COMMIT="597212e462da05a7902d6cea0ec895a0d9b8b218"

inherit golang-build golang-vcs-snapshot bash-completion-r1
ARCHIVE_URI="https://github.com/rsc/goversion/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Print version used to build Go executables"
HOMEPAGE="https://github.com/rsc/goversion https://rsc.io/goversion"
SRC_URI="${ARCHIVE_URI}"

LICENSE="BSD"
SLOT="0"
IUSE=""

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -o ${PN} . || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/${PN}
	dodoc src/${EGO_PN}/README.md
}

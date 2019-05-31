# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/${PN}/${PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-build golang-vcs
else
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
	inherit golang-build golang-vcs-snapshot
fi

DESCRIPTION="command line extension and specification for managing large files with Git"
HOMEPAGE="https://git-lfs.github.com/"

LICENSE="MIT BSD BSD-2 BSD-4 Apache-2.0"
SLOT="0"
IUSE="+doc"

DEPEND="doc? ( app-text/ronn )"

RDEPEND="dev-vcs/git"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	golang-build_src_compile

	if use doc; then
		ronn docs/man/*.ronn || die "man building failed"
	fi
}

src_install() {
	dobin git-lfs
	use doc && doman docs/man/*.1
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/git-lfs/${PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="command line extension and specification for managing large files with Git"
HOMEPAGE="https://git-lfs.github.com/"

LICENSE="MIT BSD BSD-2 BSD-4 Apache-2.0"
SLOT="0"
IUSE="+doc"

# since version 2.0.2 git-lfs uses time.Until that was introduced in golang >=1.8
# https://github.com/golang/go/commit/67ea710792eabdae1182e2bf4845f512136cccce
DEPEND=">=dev-lang/go-1.8.1:=
	doc? ( app-text/ronn )"

RDEPEND="dev-vcs/git"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	# can't use golang-build_src_compile for go generate
	# and others steps executed by build.go
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
	go run script/*.go -cmd build || die "build failed"

	if use doc; then
		ronn docs/man/*.ronn || die "man building failed"
	fi
}

src_install() {
	dobin bin/git-lfs

	use doc && doman docs/man/*.1
}

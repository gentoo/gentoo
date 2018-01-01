# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot bash-completion-r1

DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io/"
SRC_URI="https://github.com/restic/restic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGO_PN="github.com/restic/restic"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

DOCS=(
	README.rst CONTRIBUTING.md doc/010_introduction.rst doc/020_installation.rst
	doc/030_preparing_a_new_repo.rst doc/040_backup.rst doc/045_working_with_repos.rst
	doc/050_restore.rst doc/060_forget.rst doc/070_encryption.rst doc/080_examples.rst
	doc/090_participating.rst doc/100_references.rst doc/cache.rst doc/faq.rst
	doc/index.rst doc/manual_rest.rst
)

DEPEND="
	dev-lang/go
	test? ( sys-fs/fuse:0 )"

RDEPEND="sys-fs/fuse:0"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		-tags release
		-ldflags "-s -w -X main.version=${PV}"
		-asmflags "-trimpath=${S}"
		-gcflags "-trimpath=${S}"
		-o restic ${EGO_PN}/cmd/restic
	)

	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go build "${mygoargs[@]}" || die
}

src_test() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go test -timeout 30m -v -work -x ${EGO_PN}/cmd/... ${EGO_PN}/internal/... || die
}

src_install() {
	dobin restic
	einstalldocs

	newbashcomp doc/bash-completion.sh "${PN}"

	insinto /usr/share/zsh/site-functions
	newins doc/zsh-completion.zsh _restic

	local i
	for i in doc/man/*; do
		doman "$i"
	done
}

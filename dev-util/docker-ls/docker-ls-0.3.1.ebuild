# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/mayflower/${PN}"
EGIT_COMMIT="d80310976c9707e261e57ebfa9acf4e0b1781460"

inherit golang-build golang-vcs-snapshot bash-completion-r1

ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Tools for browsing and manipulating docker registries"
HOMEPAGE="https://github.com/mayflower/docker-ls"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0"
IUSE=""

RESTRICT="test"

src_prepare() {
	default
	sed -i -e "s/\"git\", \"rev-parse\", \"--short\", \"HEAD\"/\"echo\", \"${EGIT_COMMIT:0:7}\"/"\
	src/${EGO_PN}/generators/version.go || die
}

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}" go generate ${EGO_PN}/lib/... || die
	GOPATH="${WORKDIR}/${P}" go install ${EGO_PN}/cli/... || die
	popd || die
	bin/${PN} autocomplete bash > ${PN}.bash || die
	bin/${PN} autocomplete zsh > ${PN}.zsh || die
	bin/docker-rm autocomplete bash > docker-rm.bash || die
	bin/docker-rm autocomplete zsh > docker-rm.zsh || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN}/{README,CHANGELOG}.md
	newbashcomp ${PN}.bash ${PN}
	newbashcomp docker-rm.bash docker-rm
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
	newins docker-rm.zsh _docker-rm
}

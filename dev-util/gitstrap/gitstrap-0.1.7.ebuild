# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/g4s8/${PN}/cmd/gitstrap"

inherit golang-build

DESCRIPTION="Command line tool to bootstrap Github repository"
HOMEPAGE="https://github.com/g4s8/gitstrap"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="dev-vcs/git"

get_golibdir_gopath() {
	# overrides get_golibdir_gopath function
	# from golang-build eclass
	echo "${HOME}/go"
}

_go_get() {
	set -- env GOPATH="$(get_golibdir_gopath)" go get -v -u "$1"
	echo "$@"
	"$@" || die
}

src_prepare() {
	default
	mkdir -pv "$(get_golibdir_gopath)/src/github.com/g4s8" || die
	ln -snv "${WORKDIR}/${P}" "$(get_golibdir_gopath)/src/github.com/g4s8/gitstrap" || die
	_go_get github.com/google/go-github/github
	_go_get golang.org/x/oauth2
	_go_get gopkg.in/yaml.v2
}

src_install() {
	dobin ${PN}
	elog "Read the README for details: https://github.com/g4s8/gitstrap/blob/master/README.md"
}

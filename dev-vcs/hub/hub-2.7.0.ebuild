# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/github/hub
inherit bash-completion-r1

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/github/hub"
SRC_URI="https://github.com/github/hub/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://${EGO_PN}/releases/download/v${PV}/${PN}-linux-amd64-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-lang/go-1.5.1:="
RDEPEND=">=dev-vcs/git-1.7.3"

QA_FLAGS_IGNORED=".*"
RESTRICT="strip"

src_prepare() {
	mkdir -p "${HOME}/go/src/${EGO_PN%/*}" || die "mkdir failed"
	ln -snf "${S}" "${HOME}/go/src/${EGO_PN}" || die "ln failed"
	default
}

src_compile() {
	unset GOPATH
	./script/build -o bin/${PN} || die
}

#src_test() {
#	./script/test || die
#}

src_install() {
	dobin bin/${PN}
	dodoc README.md
	doman ../${PN}-linux-amd64-${PV}/share/man/man1/*.1

	newbashcomp etc/${PN}.bash_completion.sh ${PN}

	insinto /usr/share/zsh/site-functions
	newins etc/hub.zsh_completion _${PN}
}

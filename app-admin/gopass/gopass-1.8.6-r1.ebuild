# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="github.com/gopasspw/gopass"

inherit golang-vcs-snapshot golang-build bash-completion-r1

DESCRIPTION="a simple but powerful password manager for the terminal"
HOMEPAGE="https://www.gopass.pw/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0 BSD MPL-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/go-1.11"
RDEPEND="
	dev-vcs/git
	>=app-crypt/gnupg-2
"

src_install() {
	dobin gopass

	local DOCS=( src/${EGO_PN}/{CHANGELOG,CONTRIBUTING}.md src/${EGO_PN}/docs/*.md )
	einstalldocs

	# install fish completion
	./gopass completion fish > "${T}"/${PN}.fish || die
	insinto /usr/share/fish/vendor_completions.d
	doins "${T}"/${PN}.fish

	# install bash completion
	./gopass completion bash > "${T}"/${PN} || die
	dobashcomp "${T}"/${PN}

	# install zsh completion
	./gopass completion zsh > "${T}"/${PN}.zsh || die
	insinto /usr/share/zsh/site-functions
	newins "${T}"/${PN}.zsh _${PN}
}

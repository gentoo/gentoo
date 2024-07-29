# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 go-module
LONG_VERSION=v0.25.1-0-g7e9b4be

DESCRIPTION="Lab wraps Git or Hub, making it simple to interact with repositories on GitLab"
HOMEPAGE="https://zaquestion.github.io/lab/"
SRC_URI="https://github.com/zaquestion/lab/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="dev-vcs/git"

# tests try to write to /src and fetch from gitlab
RESTRICT+=" test"

src_compile() {
	emake VERSION="${LONG_VERSION}"
	mkdir -v "${T}/comp" || die
	./lab completion bash > "${T}/comp/lab" || die
	./lab completion zsh > "${T}/comp/_lab" || die
}

src_install() {
	dobin lab
	einstalldocs
	dobashcomp "${T}/comp/lab"
	insinto /usr/share/zsh/site-functions
	doins "${T}/comp/_lab"
}

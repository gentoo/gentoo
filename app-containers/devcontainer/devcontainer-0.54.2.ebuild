# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Reference implementation of the Development Containers specification"
HOMEPAGE="https://containers.dev/
	https://github.com/devcontainers/cli/"
SRC_URI="https://registry.npmjs.org/@devcontainers/cli/-/cli-${PV}.tgz
	-> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	net-libs/nodejs
"
BDEPEND="
	>=net-libs/nodejs-16[npm]
"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	# Skip, nothing to compile here.
	:
}

src_install() {
	local -a my_npm_opts=(
		--audit false
		--color false
		--foreground-scripts
		--global
		--offline
		--omit dev
		--prefix "${ED}/usr"
		--progress false
		--verbose
	)
	npm "${my_npm_opts[@]}" install "${DISTDIR}/${P}.tgz" || die "npm install failed"

	einstalldocs
}

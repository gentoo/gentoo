# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Superset of JavaScript with optional static typing, classes and interfaces"
HOMEPAGE="https://www.typescriptlang.org/
	https://github.com/microsoft/TypeScript/"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"
S="${WORKDIR}"/package

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

RDEPEND="net-libs/nodejs"
BDEPEND=">=net-libs/nodejs-16[npm]"

src_compile() {
	# Skip, nothing to compile here.
	:
}

src_install() {
	local myopts=(
		--audit false
		--color false
		--foreground-scripts
		--global
		--offline
		--omit dev
		--prefix "${ED}"/usr
		--progress false
		--verbose
	)
	npm ${myopts[@]} install "${DISTDIR}"/${P}.tgz || die "npm install failed"

	dodoc *.md *.txt
}

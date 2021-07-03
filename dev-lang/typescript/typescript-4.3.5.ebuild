# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Superset of JavaScript with optional static typing, classes and interfaces"
HOMEPAGE="https://www.typescriptlang.org"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND=""
RDEPEND="net-libs/nodejs"
BDEPEND=">=net-libs/nodejs-16[npm]"

S="${WORKDIR}/package"

src_compile() {
	# nothing to compile here
	:
}

src_install() {
	npm \
		--audit false \
		--color false \
		--foreground-scripts \
		--global \
		--offline \
		--omit dev \
		--prefix "${ED}"/usr \
		--progress false \
		--verbose \
		install "${DISTDIR}/${P}".tgz || die "npm install failed"

	einstalldocs
}

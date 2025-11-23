# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="UglifyJS"
DESCRIPTION="JavaScript parser, minifier, compressor and beautifier toolkit"
HOMEPAGE="https://lisperator.net/uglifyjs/"
SRC_URI="https://github.com/mishoo/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

S="${WORKDIR}/${MY_PN}-${PV}"

NPM_FLAGS=(
	--audit false
	--color false
	--foreground-scripts
	--global
	--offline
	--progress false
	--save false
	--verbose
)

src_compile() {
	npm "${NPM_FLAGS[@]}" pack || die
}

src_install() {
	npm "${NPM_FLAGS[@]}" \
		--prefix "${ED}"/usr \
		install \
		uglify-js-${PV}.tgz || die
}

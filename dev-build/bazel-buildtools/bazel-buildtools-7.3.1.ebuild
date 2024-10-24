# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_PN="buildtools"

inherit go-module

DESCRIPTION="Tools for working with Google's Bazel BUILD files."
HOMEPAGE="https://github.com/bazelbuild/buildtools/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/bazelbuild/${APP_PN}.git"
else
	SRC_URI="https://github.com/bazelbuild/${APP_PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${APP_PN}-${PV}"

	KEYWORDS="~amd64 ~arm64 ~x86"
fi

SRC_URI+="
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"

DOCS=( README.md WARNINGS.md )

src_prepare() {
	default

	rm ./warn/docs/docs.go || die
}

src_compile() {
	local -r go_ldopts="
		-X main.buildScmRevision=v${PV}
		-X main.buildVersion=${PV}
	"
	local -a -r go_buildopts=(
		-ldflags "${go_ldopts}"
		-o ./bin/
	)
	ego build "${go_buildopts[@]}" ./...
}

src_install() {
	exeinto /usr/bin
	doexe ./bin/{buildifier{,2},buildozer}
	newexe ./bin/generatetables bazel-generatetables
	newexe ./bin/unused_deps bazel-unused_deps

	local app=""
	for app in buildifier buildozer unused_deps ; do
		newdoc "${S}/${app}/README.md" "${app}.md"
	done

	einstalldocs
}

pkg_postinst() {
	einfo 'The "generatetables" binary is installed as "bazel-generatetables"'
	einfo 'and the "unused_deps" binary is installed as "bazel-unused_deps"'.
}

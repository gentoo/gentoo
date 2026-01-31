# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN="buildtools"

inherit go-module

DESCRIPTION="Tools for working with Google's Bazel BUILD files."
HOMEPAGE="https://github.com/bazelbuild/buildtools/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/bazelbuild/${REAL_PN}"
else
	SRC_URI="https://github.com/bazelbuild/${REAL_PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${REAL_PN}-${PV}"

	KEYWORDS="~amd64 ~arm64 ~x86"
fi

SRC_URI+="
	https://dev.gentoo.org/~xgqt/distfiles/deps/${PN}-8.2.0-deps.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"

DOCS=( README.md WARNINGS.md )

src_prepare() {
	default

	rm ./warn/docs/docs.go || die
}

src_compile() {
	local go_ldopts="
		-X main.buildScmRevision=v${PV}
		-X main.buildVersion=${PV}
	"
	local -a go_buildopts=(
		-ldflags "${go_ldopts}"
		-o ./bin/
	)
	ego build "${go_buildopts[@]}" ./...
}

src_install() {
	exeinto /usr/bin
	doexe ./bin/{buildifier,buildozer}
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

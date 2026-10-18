# Copyright 2017-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EGO_PN=github.com/git-lfs/git-lfs
# Update the ID as it's included in each build.
COMMIT_ID="aece9221f8c09221a14395d964806b956289bc07"

inherit edo go-module shell-completion

DESCRIPTION="Command line extension and specification for managing large files with git"
HOMEPAGE="
	https://git-lfs.com
	https://github.com/git-lfs/git-lfs
"

if [[ "${PV}" = 9999* ]]; then
	EGIT_REPO_URI="https://${EGO_PN}"
	inherit git-r3
else
	SRC_URI="https://${EGO_PN}/releases/download/v${PV}/${PN}-vendor-v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0 BSD BSD-2 BSD-4 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="doc test"

BDEPEND="
	>=dev-lang/go-1.25.0
	doc? ( dev-ruby/asciidoctor )
"
RDEPEND="dev-vcs/git"

RESTRICT+=" !test? ( test )"
# The golang compiler already strips.
QA_PRESTRIPPED="/usr/bin/git-lfs"

DOCS=(
	CHANGELOG.md
	CODE-OF-CONDUCT.md
	CONTRIBUTING.md
	README.md
	SECURITY.md
)

src_compile() {
	export CGO_ENABLED=0

	# Flags -w, -s: Omit debugging information to reduce binary size,
	# see https://golang.org/cmd/link/.
	local mygobuildargs=(
		-ldflags="-X ${EGO_PN}/config.GitCommit=${COMMIT_ID} -s -w"
		-gcflags=" "
		-trimpath
		-v -work -x
	)
	ego build "${mygobuildargs[@]}" -o git-lfs git-lfs.go

	if use doc; then
		for doc in docs/man/*adoc;
		do
			edo asciidoctor -b manpage "${doc}"
		done
	fi

	# Generate auto-completion scripts.
	# bug 914542
	./git-lfs completion bash > "${PN}.bash" || die
	./git-lfs completion fish > "${PN}.fish" || die
	./git-lfs completion zsh > "${PN}.zsh" || die
}

src_install() {
	dobin git-lfs
	einstalldocs

	# Install auto-completion scripts generated earlier.
	# bug 914542
	newbashcomp "${PN}.bash" "${PN}"
	dofishcomp "${PN}.fish"
	newzshcomp "${PN}.zsh" "_${PN}"

	use doc && doman docs/man/*.1
}

src_test() {
	local mygotestargs=(
		-ldflags="-X ${EGO_PN}/config.GitCommit=${COMMIT_ID}"
	)
	ego test "${mygotestargs[@]}" ./...
}

pkg_postinst () {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog ""
		elog "Run 'git lfs install' once for each user account manually."
		elog "For more details see https://bugs.gentoo.org/show_bug.cgi?id=733372."
	fi
}

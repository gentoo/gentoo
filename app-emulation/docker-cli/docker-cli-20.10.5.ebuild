# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GIT_COMMIT=55c4c88966
EGO_PN="github.com/docker/cli"
inherit bash-completion-r1  golang-vcs-snapshot

DESCRIPTION="the command line binary for docker"
HOMEPAGE="https://www.docker.com/"
MY_PV=${PV/_/-}
SRC_URI="https://github.com/docker/cli/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="hardened"

RDEPEND="!<app-emulation/docker-20.10.1"
BDEPEND="dev-go/go-md2man"

RESTRICT="installsources strip"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_prepare() {
	default
	sed -i 's@dockerd\?\.exe@@g' contrib/completion/bash/docker || die
}

src_compile() {
	export DISABLE_WARN_OUTSIDE_CONTAINER=1
	export GOPATH="${WORKDIR}/${P}"
	# setup CFLAGS and LDFLAGS for separate build target
	# see https://github.com/tianon/docker-overlay/pull/10
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="-L${ROOT}/usr/$(get_libdir)"
		emake \
		LDFLAGS="$(usex hardened '-extldflags -fno-PIC' '')" \
		VERSION="$(cat VERSION)" \
		GITCOMMIT="${GIT_COMMIT}" \
		dynbinary

	# build man pages
	# see "cli/scripts/docs/generate-man.sh" (which also does "go get" for go-md2man)
	go build -o "${T}"/gen-manpages ./man ||
		die 'build gen-manpages failed'
	"${T}"/gen-manpages --root "$(pwd)" --target "$(pwd)"/man/man1 ||
		die 'gen-manpages failed'
	./man/md2man-all.sh -q ||
		die 'md2man-all.sh failed'
}

src_install() {
	dobin build/docker
	doman man/man*/*
	dobashcomp contrib/completion/bash/*
	bashcomp_alias docker dockerd
	insinto /usr/share/fish/vendor_completions.d/
	doins contrib/completion/fish/docker.fish
	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/_*
}

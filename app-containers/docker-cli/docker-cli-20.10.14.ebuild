# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public Lic
EAPI=7
GIT_COMMIT=a224086349
EGO_PN="github.com/docker/cli"
MY_PV=${PV/_/-}
inherit bash-completion-r1  golang-vcs-snapshot

DESCRIPTION="the command line binary for docker"
HOMEPAGE="https://www.docker.com/"
SRC_URI="https://github.com/docker/cli/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="hardened"

RDEPEND="!<app-containers/docker-20.10.1"
BDEPEND="
	>=dev-lang/go-1.16.6
	dev-go/go-md2man"

RESTRICT="installsources strip test"

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
	export CGO_CFLAGS="-I${ESYSROOT}/usr/include"
	export CGO_LDFLAGS="-L${ESYSROOT}/usr/$(get_libdir)"
		emake \
		LDFLAGS="$(usex hardened '-extldflags -fno-PIC' '')" \
		VERSION="${PV}" \
		GITCOMMIT="${GIT_COMMIT}" \
		dynbinary

	# build man pages
	# see "cli/scripts/docs/generate-man.sh" (which also does "go get" for go-md2man)
	mkdir -p ./man/man1 || die "mkdir failed"
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

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GIT_COMMIT=ced0996600
EGO_PN="github.com/docker/cli"
MY_PV=${PV/_/-}
inherit bash-completion-r1  golang-vcs-snapshot

DESCRIPTION="the command line binary for docker"
HOMEPAGE="https://www.docker.com/"
SRC_URI="https://github.com/docker/cli/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-man.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="hardened selinux"

RDEPEND="!<app-containers/docker-20.10.1
	selinux? ( sec-policy/selinux-docker )"
BDEPEND="
	>=dev-lang/go-1.16.6"

RESTRICT="installsources strip test"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_unpack() {
	golang-vcs-snapshot_src_unpack
	set -- ${A}
	unpack ${2}
}

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
}

src_install() {
	dobin build/docker
	doman "${WORKDIR}"/man/man?/*
	dobashcomp contrib/completion/bash/*
	bashcomp_alias docker dockerd
	insinto /usr/share/fish/vendor_completions.d/
	doins contrib/completion/fish/docker.fish
	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/_*
}

pkg_postinst() {
	has_version "app-containers/docker-buildx" && return
	ewarn "the 'docker build' command is deprecated and will be removed in a"
	ewarn "future release. If you need this functionality, install"
	ewarn "app-containers/docker-buildx."
}

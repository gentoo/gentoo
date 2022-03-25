# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GIT_REVISION=1407cab509ff0d96baa4f0eb6ff9980270e6e620
inherit go-module systemd

DESCRIPTION="A daemon to control runC"
HOMEPAGE="https://containerd.io/"
SRC_URI="https://github.com/containerd/containerd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="apparmor btrfs device-mapper +cri hardened +seccomp selinux test"

DEPEND="
	btrfs? ( sys-fs/btrfs-progs )
	seccomp? ( sys-libs/libseccomp )
"

# recommended version of runc is found in script/setup/runc-version
RDEPEND="
	${DEPEND}
	~app-containers/runc-1.0.3
"

# bug #835367 for Go < 1.18 dep
BDEPEND="
	<dev-lang/go-1.18
	dev-go/go-md2man
	virtual/pkgconfig
"

# tests require root or docker
# upstream does not recommend stripping binary
RESTRICT+=" strip test"

src_prepare() {
	default
	sed -i \
		-e "s/-s -w//" \
		Makefile || die
	sed -i \
		-e "s:/usr/local:/usr:" \
		containerd.service || die
}

src_compile() {
	local options=(
		$(usev apparmor)
		$(usex btrfs "" "no_btrfs")
		$(usex cri "" "no_cri")
		$(usex device-mapper "" "no_devmapper")
		$(usev seccomp)
		$(usev selinux)
	)

	myemakeargs=(
		BUILDTAGS="${options[*]}"
		LDFLAGS="$(usex hardened '-extldflags -fno-PIC' '')"
		REVISION="${GIT_REVISION}"
		VERSION=v${PV}
	)

	# race condition in man target https://bugs.gentoo.org/765100
	# we need to explicitly specify GOFLAGS for "go run" to use vendor source
	emake "${myemakeargs[@]}" man -j1 #nowarn
	emake "${myemakeargs[@]}" all

}

src_install() {
	dobin bin/*
	doman man/*
	newinitd "${FILESDIR}"/${PN}.initd "${PN}"
	systemd_dounit containerd.service
	keepdir /var/lib/containerd

	# we already installed manpages, remove markdown source
	# before installing docs directory
	rm -r docs/man || die

	local DOCS=( ADOPTERS.md README.md RELEASES.md ROADMAP.md SCOPE.md docs/. )
	einstalldocs
}

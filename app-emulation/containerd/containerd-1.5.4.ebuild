# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd toolchain-funcs

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
	~app-emulation/runc-1.0.0
"

BDEPEND="
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
		GO_BUILD_FLAGS="-mod vendor"
		LDFLAGS="$(usex hardened '-extldflags -fno-PIC' '')"
		REVISION=69107e47a62e1d690afa2b9b1d43f8ece3ff4483
		VERSION=v${PV}
	)

	# race condition in man target https://bugs.gentoo.org/765100
	# we need to explicitly specify GOFLAGS for "go run" to use vendor source
	GOFLAGS="-v -x -mod=vendor" emake "${myemakeargs[@]}" man -j1 #nowarn
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

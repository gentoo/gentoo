# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CONTAINERD_COMMIT=7b11cfaabd73bb80907dd23182b9347b4245eb5d
EGO_PN="github.com/containerd/${PN}"
inherit golang-vcs-snapshot

DESCRIPTION="A daemon to control runC"
HOMEPAGE="https://containerd.io/"
SRC_URI="https://github.com/containerd/containerd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 ~x86"
IUSE="apparmor btrfs device-mapper +cri hardened +seccomp selinux test"

DEPEND="
	btrfs? ( sys-fs/btrfs-progs )
	seccomp? ( sys-libs/libseccomp )
"

# recommended version of runc is found in script/setup/runc-version
RDEPEND="
	${DEPEND}
	~app-containers/runc-1.0.2
"

# bug #835367 for Go < 1.18 dep
BDEPEND="
	<dev-lang/go-1.18
	dev-go/go-md2man
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

# tests require root or docker
# upstream does not recommend stripping binary
RESTRICT+=" strip test"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_prepare() {
	default
	sed -i -e "s/git describe --match.*$/echo ${PV})/"\
		-e "s/git rev-parse HEAD.*$/echo ${CONTAINERD_COMMIT})/"\
		-e "s/-s -w//" \
		Makefile || die
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
	)

	export GOPATH="${WORKDIR}/${P}" # ${PWD}/vendor
	export GOFLAGS="-v -x -mod=vendor"
	# race condition in man target https://bugs.gentoo.org/765100
	emake "${myemakeargs[@]}" man -j1 #nowarn
	emake "${myemakeargs[@]}" all
}

src_install() {
	dobin bin/*
	doman man/*
	newinitd "${FILESDIR}"/${PN}.initd "${PN}"
	keepdir /var/lib/containerd

	# we already installed manpages, remove markdown source
	# before installing docs directory
	rm -r docs/man || die

	local DOCS=( README.md PLUGINS.md docs/. )
	einstalldocs
}

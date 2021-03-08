# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CONTAINERD_COMMIT=05f951a3781f4f2c1911b05e61c160e9c30eaa8e
EGO_PN="github.com/containerd/${PN}"
inherit golang-vcs-snapshot toolchain-funcs

DESCRIPTION="A daemon to control runC"
HOMEPAGE="https://containerd.io/"
SRC_URI="https://github.com/containerd/containerd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="apparmor btrfs device-mapper +cri hardened +seccomp selinux test"

DEPEND="
	btrfs? ( sys-fs/btrfs-progs )
	seccomp? ( sys-libs/libseccomp )
"

RDEPEND="
	${DEPEND}
	~app-emulation/runc-1.0.0_rc92
"

BDEPEND="
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
		DESTDIR="${ED}"
		LDFLAGS="$(usex hardened '-extldflags -fno-PIC' '')"
	)

	export GOPATH="${WORKDIR}/${P}" # ${PWD}/vendor
	export GOFLAGS="-v -x -mod=vendor"
	emake "${myemakeargs[@]}" all man
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

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot linux-info

# update on bump, look for https://github.com/docker\
# docker-ce/blob/<docker ver OR branch>/components/engine/hack/dockerfile/install/runc.installer
RUNC_COMMIT="dc9208a3303feef5b3839f4323d9beb36df0a9dd"
CONFIG_CHECK="~USER_NS"
EGO_PN="github.com/opencontainers/${PN}"

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"
SRC_URI="https://github.com/opencontainers/${PN}/archive/v${RUNC_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 ~x86"
IUSE="apparmor +ambient hardened +kmem +seccomp selinux test"

DEPEND="seccomp? ( sys-libs/libseccomp )"

RDEPEND="
	${DEPEND}
	!app-emulation/docker-runc
	apparmor? ( sys-libs/libapparmor )
"

BDEPEND="
	dev-go/go-md2man
	test? ( "${RDEPEND}" )
"

# tests need busybox binary, and portage namespace
# sandboxing disabled: mount-sandbox pid-sandbox ipc-sandbox
# majority of tests pass
RESTRICT+=" test"

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ESYSROOT}/usr/include"
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')
		-L${ESYSROOT}/usr/$(get_libdir)"

	# build up optional flags
	local options=(
		$(usev ambient)
		$(usev apparmor)
		$(usev seccomp)
		$(usev selinux)
		$(usex kmem '' 'nokmem')
	)

	myemakeargs=(
		BUILDTAGS="${options[*]}"
		COMMIT=${RUNC_COMMIT}
		GOPATH="${S}"
		-C "src/${EGO_PN}"
	)

	emake "${myemakeargs[@]}" runc man
}

src_install() {
	myemakeargs+=(
		PREFIX="${ED}/usr"
		BINDIR="${ED}/usr/bin"
		MANDIR="${ED}/usr/share/man"
	)
	emake "${myemakeargs[@]}" install install-man install-bash

	local DOCS=( src/"${EGO_PN}"/{README.md,PRINCIPLES.md,docs/.} )
	einstalldocs
}

src_test() {
	emake "${myemakeargs[@]}" localunittest
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

# update on bump, look for commit ID on release tag.
# https://github.com/opencontainers/runc
RUNC_COMMIT=59923ef18c98053ddb1acf23ecba10344056c28e

CONFIG_CHECK="~USER_NS"

DESCRIPTION="runc container cli tools"
HOMEPAGE="https://github.com/opencontainers/runc/"
MY_PV="${PV/_/-}"
SRC_URI="https://github.com/opencontainers/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="apparmor hardened +kmem +seccomp selinux test"

COMMON_DEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	!app-emulation/docker-runc
	selinux? ( sec-policy/selinux-container )"
BDEPEND="
	dev-go/go-md2man
	test? ( "${RDEPEND}" )"

# tests need busybox binary, and portage namespace
# sandboxing disabled: mount-sandbox pid-sandbox ipc-sandbox
# majority of tests pass
RESTRICT+=" test"

src_compile() {
	# build up optional flags
	local options=(
		$(usev apparmor)
		$(usev seccomp)
		$(usex kmem '' 'nokmem')
	)

	myemakeargs=(
		BUILDTAGS="${options[*]}"
		COMMIT="${RUNC_COMMIT}"
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

	local DOCS=( README.md PRINCIPLES.md docs/. )
	einstalldocs
}

src_test() {
	emake "${myemakeargs[@]}" localunittest
}

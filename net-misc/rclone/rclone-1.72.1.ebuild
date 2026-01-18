# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion check-reqs edo go-module

DESCRIPTION="A program to sync files to and from various cloud storage providers"
HOMEPAGE="https://rclone.org/
	https://github.com/rclone/rclone/"

SRC_URI="
	https://github.com/rclone/rclone/releases/download/v${PV}/${PN}-v${PV}.tar.gz
	https://github.com/rclone/rclone/releases/download/v${PV}/${PN}-v${PV}-vendor.tar.gz
"
S="${WORKDIR}/rclone-v${PV}"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	sys-fs/fuse:3=
"

CHECKREQS_DISK_BUILD="2500M"

pkg_setup() {
	check-reqs_pkg_setup
}

src_unpack() {
	mkdir -p "${S}" || die
	ln -s "../vendor" "${S}/vendor" || die

	go-module_src_unpack
}

src_compile() {
	local go_ldflags="
		-X github.com/rclone/rclone/fs.Version=${PV}
	"
	local -a go_buildargs=(
		-ldflags "${go_ldflags}"
		-mod=vendor
		-o ./
	)
	ego build "${go_buildargs[@]}"

	edob ./rclone genautocomplete bash "${PN}.bash"
	edob ./rclone genautocomplete zsh "${PN}.zsh"
	edob ./rclone genautocomplete fish "${PN}.fish"
}

src_test() {
	# Setting CI skips unreliable tests, see "fstest/testy/testy.go"
	# "TestAddPlugin" and "TestRemovePlugin" fail.
	local -x CI="true"
	local -x RCLONE_CONFIG="/not_found"

	ego test -mod=vendor -v -run "!Test.*Plugin" ./...
}

src_install() {
	exeinto /usr/bin
	doexe "${PN}"
	dosym -r "/usr/bin/${PN}" /usr/bin/mount.rclone
	dosym -r "/usr/bin/${PN}" /usr/bin/rclonefs

	newbashcomp "${PN}.bash" "${PN}"
	newzshcomp "${PN}.zsh" "_${PN}"
	dofishcomp "${PN}.fish"

	doman "${PN}.1"
	einstalldocs
}

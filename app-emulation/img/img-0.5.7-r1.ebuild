# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/genuinetools/img"

inherit golang-vcs-snapshot

DESCRIPTION="Standalone daemon-less unprivileged Dockerfile and OCI container image builder"
HOMEPAGE="https://github.com/genuinetools/img"
SRC_URI="https://github.com/genuinetools/img/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
IUSE="seccomp"

DEPEND="seccomp? ( sys-libs/libseccomp )"
RDEPEND="${DEPEND}
	app-emulation/runc"

src_compile() {
	GOPATH="${S}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		IMG_DISABLE_EMBEDDED_RUNC=1 \
		go build -v -work -x -tags "noembed $(usev seccomp)" \
			-ldflags="-s -w -X ${EGO_PN}/version.VERSION=${PV}" "${EGO_PN}" || die
}

src_install() {
	dobin img
	dodoc "src/${EGO_PN}"/{README.md,AUTHORS}
}

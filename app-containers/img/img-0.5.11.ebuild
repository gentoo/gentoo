# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Standalone daemon-less unprivileged Dockerfile and OCI container image builder"
HOMEPAGE="https://github.com/genuinetools/img"
SRC_URI="https://github.com/genuinetools/img/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
IUSE="seccomp"

DEPEND="seccomp? ( sys-libs/libseccomp )"
RDEPEND="${DEPEND}
	app-containers/runc"

src_compile() {
	IMG_DISABLE_EMBEDDED_RUNC=1 \
		ego build \
		-mod=vendor \
		-tags "noembed $(usev seccomp)" \
		-ldflags="-X version.VERSION=${PV}"
}

src_install() {
	dobin img
	dodoc README.md AUTHORS
}

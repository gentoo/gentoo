# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit bash-completion-r1 golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/containers/buildah"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="ostree selinux"
EGO_PN="${HOMEPAGE#*//}"
EGIT_COMMIT="v${PV}"
GIT_COMMIT="5f95bd9"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RDEPEND="app-crypt/gpgme:=
	app-emulation/skopeo
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-fs/lvm2:=
	sys-libs/libseccomp:=
	selinux? ( sys-libs/libselinux:= )"
DEPEND="${RDEPEND}"
RESTRICT="test"
REQUIRED_USE="!selinux? ( !ostree )"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_prepare() {
	default
	sed -e 's|^\(GIT_COMMIT ?= \).*|\1'${GIT_COMMIT}'|' -i Makefile || die

	[[ -f ostree_tag.sh ]] || die
	use ostree || { echo -e "#!/bin/sh\necho containers_image_ostree_stub" > \
		ostree_tag.sh || die; }

	[[ -f selinux_tag.sh ]] || die
	use selinux || { echo -e "#!/bin/sh\ntrue" > \
		selinux_tag.sh || die; }
}

src_compile() {
	GOPATH="${WORKDIR}/${P}" emake all
}

src_install() {
	dodoc CHANGELOG.md CONTRIBUTING.md README.md install.md troubleshooting.md
	doman docs/*.1
	dodoc -r docs/tutorials
	dobin ${PN} imgtype
	dobashcomp contrib/completions/bash/buildah
}

src_test() {
	GOPATH="${WORKDIR}/${P}" emake test-unit
}

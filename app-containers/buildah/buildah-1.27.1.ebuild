# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module
GIT_COMMIT=395790ce

DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/containers/buildah"
SRC_URI="https://github.com/containers/buildah/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="selinux"

RDEPEND="app-crypt/gpgme:=
	app-containers/skopeo
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-apps/shadow:=
	sys-fs/lvm2:=
	sys-libs/libseccomp:=
	selinux? ( sys-libs/libselinux:= )"
DEPEND="${RDEPEND}"

RESTRICT+=" test"

src_prepare() {
	default
	[[ -f selinux_tag.sh ]] || die
	use selinux || { echo -e "#!/bin/sh\ntrue" > \
		selinux_tag.sh || die; }
	sed -i -e 's/make -C/$(MAKE) -C/' Makefile || die 'sed failed'
}

src_compile() {
	emake GIT_COMMIT=${GIT_COMMIT} all
}

src_install() {
	dodoc CHANGELOG.md CONTRIBUTING.md README.md install.md troubleshooting.md
	doman docs/*.1
	dodoc -r docs/tutorials
	dobin bin/{${PN},imgtype}
	dobashcomp contrib/completions/bash/buildah
}

src_test() {
	emake test-unit
}

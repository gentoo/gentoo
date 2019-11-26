# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

KEYWORDS="~amd64"
DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/containers/buildah"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
IUSE="selinux"
EGIT_COMMIT="v${PV}"
GIT_COMMIT="7c97335"
CONTAINERS_STORAGE_PATCH="containers-storage-1.14.0-vfs-user-xattrs.patch"
SRC_URI="https://github.com/containers/buildah/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/containers/storage/pull/466.patch -> ${CONTAINERS_STORAGE_PATCH}"
RDEPEND="app-crypt/gpgme:=
	app-emulation/skopeo
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-fs/lvm2:=
	sys-libs/libseccomp:=
	selinux? ( sys-libs/libselinux:= )"
DEPEND="${RDEPEND}"
RESTRICT="test"

src_prepare() {
	default
	sed -e 's| \([ab]\)/| \1/vendor/github.com/containers/storage/|' < \
		"${DISTDIR}/${CONTAINERS_STORAGE_PATCH}" > \
		"${WORKDIR}/${CONTAINERS_STORAGE_PATCH}" || die
	eapply "${WORKDIR}/${CONTAINERS_STORAGE_PATCH}"
	sed -e 's|^\(GIT_COMMIT ?= \).*|\1'${GIT_COMMIT}'|' -i Makefile || die

	[[ -f selinux_tag.sh ]] || die
	use selinux || { echo -e "#!/bin/sh\ntrue" > \
		selinux_tag.sh || die; }
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	emake all
}

src_install() {
	dodoc CHANGELOG.md CONTRIBUTING.md README.md install.md troubleshooting.md
	doman docs/*.1
	dodoc -r docs/tutorials
	dobin ${PN} imgtype
	dobashcomp contrib/completions/bash/buildah
}

src_test() {
	emake test-unit
}

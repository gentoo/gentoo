# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
EGO_PN="github.com/opencontainers/${PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	MY_PV="${PV/_/-}"
	EGIT_COMMIT="v${MY_PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="apparmor +seccomp"

DEPEND=""
RDEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )
"

S=${WORKDIR}/${P}/src/${EGO_PN}

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="-L${ROOT}/usr/$(get_libdir)"

	# Setup GOPATH so things build
	rm -rf .gopath
	mkdir -p .gopath/src/"$(dirname "${GITHUB_URI}")"
	ln -sf ../../../.. .gopath/src/"${GITHUB_URI}"
	export GOPATH="${PWD}/.gopath:${PWD}/vendor"

	# build up optional flags
	local options=(
		$(usex apparmor 'apparmor')
		$(usex seccomp 'seccomp')
	)

	emake BUILDTAGS="${options[*]}"
}

src_install() {
	dobin runc
}

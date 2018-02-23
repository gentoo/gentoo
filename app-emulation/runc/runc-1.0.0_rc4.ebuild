# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/opencontainers/${PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-build golang-vcs
else
	MY_PV="${PV/_/-}"
	EGIT_COMMIT="v${MY_PV}"
	RUNC_COMMIT="2e7cfe0" # Change this when you update the ebuild
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~ppc64"
	inherit golang-build golang-vcs-snapshot
fi

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+ambient apparmor hardened +seccomp"

RDEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )
	!app-emulation/docker-runc
"

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')
		-L${ROOT}/usr/$(get_libdir)"

	# build up optional flags
	local options=(
		$(usex ambient 'ambient')
		$(usex apparmor 'apparmor')
		$(usex seccomp 'seccomp')
	)

	GOPATH="${S}"\
		emake BUILDTAGS="${options[*]}" \
		COMMIT="${RUNC_COMMIT}" -C src/${EGO_PN}
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin runc
	dodoc README.md PRINCIPLES.md
	popd || die
}

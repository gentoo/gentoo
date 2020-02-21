# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/opencontainers/${PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-build golang-vcs
else
	MY_PV="${PV/_/-}"
	RUNC_COMMIT="d736ef14f0288d6993a1845745d6756cfc9ddd5a" # Change this when you update the ebuild
	SRC_URI="https://${EGO_PN}/archive/${RUNC_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64"
	inherit golang-build golang-vcs-snapshot
fi

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+ambient apparmor hardened +kmem +seccomp"

RDEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )
	!app-emulation/docker-runc
"

src_prepare() {
	pushd src/${EGO_PN}
	default
	sed -i -e "/^GIT_BRANCH/d"\
		-e "/^GIT_BRANCH_CLEAN/d"\
		-e "/^COMMIT_NO/d"\
		-e "s/COMMIT :=.*/COMMIT := ${RUNC_COMMIT}/"\
		Makefile || die
	popd || die
}

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')
		-L${ROOT}/usr/$(get_libdir)"

	# build up optional flags
	local options=(
		$(usex ambient 'ambient' '')
		$(usex apparmor 'apparmor' '')
		$(usex seccomp 'seccomp' '')
		$(usex kmem '' 'nokmem')
	)

	GOPATH="${S}" emake BUILDTAGS="${options[*]}" -C src/${EGO_PN}
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin runc
	dodoc README.md PRINCIPLES.md
	popd || die
}

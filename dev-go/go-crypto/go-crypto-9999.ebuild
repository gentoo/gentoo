# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_SRC=golang.org/x/crypto
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="aabede6cba87e37f413b3e60ebfc214f8eeca1b0"
	SRC_URI="https://github.com/golang/crypto/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go supplementary cryptography libraries"
HOMEPAGE="https://godoc.org/golang.org/x/crypto"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=">=dev-go/go-sys-0_pre20180816:="
RDEPEND=""

src_prepare() {
	default
	sed -e 's:TestLockOpenSSHAgent(:_\0:' \
		-i src/${EGO_SRC}/ssh/agent/client_test.go || die
}

src_compile() {
	# Exclude $(get_golibdir_gopath) from GOPATH, for bug 577908 which may
	# or may not manifest, depending on what libraries are installed.
	mkdir -p "${T}/golibdir/src/golang.org/x" || die
	ln -s "$(get_golibdir_gopath)/src/golang.org/x/sys" "${T}/golibdir/src/golang.org/x/sys" || die
	GOPATH="${S}:${T}/golibdir" GOBIN="$(go env GOROOT)/bin" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_test() {
	# Exclude $(get_golibdir_gopath) from GOPATH
	GOPATH="${S}:${T}/golibdir" GOBIN="$(go env GOROOT)/bin" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	rm -rf "${S}/src/${EGO_SRC}/.git"* || die
	golang_install_pkgs
}

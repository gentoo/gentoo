# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGO_PN=golang.org/x/crypto/...
EGO_SRC=golang.org/x/crypto

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="1f22c0103821b9390939b6776727195525381532"
	SRC_URI="https://github.com/golang/crypto/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go supplementary cryptography libraries"
HOMEPAGE="https://godoc.org/golang.org/x/crypto"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	# disable broken tests
	sed -e 's:TestAgentForward(:_\0:' \
		-i src/${EGO_SRC}/ssh/test/agent_unix_test.go || die
	sed -e 's:TestRunCommandSuccess(:_\0:' \
		-e 's:TestRunCommandStdin(:_\0:' \
		-e 's:TestRunCommandStdinError(:_\0:' \
		-e 's:TestRunCommandWeClosed(:_\0:' \
		-e 's:TestFuncLargeRead(:_\0:' \
		-e 's:TestKeyChange(:_\0:' \
		-e 's:TestValidTerminalMode(:_\0:' \
		-i src/${EGO_SRC}/ssh/test/session_test.go || die
}

src_compile() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	rm -rf "${T}/goroot/src/${EGO_SRC}" || die
	rm -rf "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" || die
	export GOROOT="${T}/goroot"
	# Exclude $(get_golibdir_gopath) from GOPATH, for bug 577908 which may
	# or may not manifest, depending on what libraries are installed.
	export GOPATH="${WORKDIR}/${P}"
	go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_test() {
	# Exclude $(get_golibdir_gopath) from GOPATH
	go test -v -work -x "${EGO_PN}" || die
}

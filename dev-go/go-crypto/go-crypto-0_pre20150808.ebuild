# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EGO_PN=golang.org/x/crypto/...
EGO_SRC=golang.org/x/crypto

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="83f1503f771a82af8a31f358eb825e9efb5dae6c"
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
	golang-build_src_compile
}

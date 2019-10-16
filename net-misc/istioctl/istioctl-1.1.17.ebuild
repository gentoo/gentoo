# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

GIT_COMMIT="149c2fc"

KEYWORDS="~amd64"
DESCRIPTION="Istio configuration command line utility"
EGO_PN="istio.io/istio"
HOMEPAGE="https://github.com/istio/istio"
MY_PV=${PV/_/-}
SRC_URI="https://github.com/istio/istio/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd "src/${EGO_PN}" || die
	BUILDINFO="istio.io/istio/pkg/version.buildVersion=${PV}
		istio.io/istio/pkg/version.buildGitRevision=${GIT_COMMIT}
		istio.io/istio/pkg/version.buildStatus=Clean" \
	VERBOSE=1 GOPATH="${WORKDIR}/${P}" TAG=${PV} emake istioctl
	popd || die
}

src_install() {
	dobin out/linux_amd64/release/${PN}
	pushd "src/${EGO_PN}" || die
	dodoc README.md
}

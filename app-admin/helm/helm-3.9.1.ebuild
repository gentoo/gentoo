# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 go-module
GIT_COMMIT=a7c043acb5ff905c261cfdc923a35776ba5e66e4
GIT_SHA=a7c043ac
MY_PV=${PV/_rc/-rc.}

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://github.com/helm/helm https://helm.sh"
SRC_URI="https://github.com/helm/helm/archive/v${MY_PV}.tar.gz -> k8s-${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT=" test"

src_compile() {
	emake \
		GOFLAGS="${GOFLAGS}" \
		LDFLAGS="" \
		GIT_COMMIT=${GIT_COMMIT} \
		GIT_SHA=${GIT_SHA} \
		GIT_TAG=v${MY_PV} \
		GIT_DIRTY=clean \
		build
	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
}

src_install() {
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}

	dobin bin/${PN}
	dodoc README.md
}

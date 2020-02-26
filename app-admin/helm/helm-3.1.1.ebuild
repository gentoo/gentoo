# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module bash-completion-r1

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://github.com/helm/helm https://helm.sh"

MY_PV=${PV/_rc/-rc.}
SRC_URI="https://github.com/helm/helm/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip test"

GIT_COMMIT=afe70585407b420d0097d07b21c47dc511525ac8

src_prepare() {
	default
	mv ../vendor .
	sed -i -e "s/git rev-parse HEAD/echo ${GIT_COMMIT}/"\
		-e "s/git rev-parse --short HEAD/echo ${GIT_COMMIT:0:7}/"\
		-e "s#git describe --tags --abbrev=0 --exact-match 2>/dev/null#echo v${PV}#"\
		-e 's/test -n "`git status --porcelain`" && echo "dirty" || //' \
		-e "/GOFLAGS    :=/d" \
		Makefile || die
}

src_compile() {
	emake GOFLAGS="-mod=vendor" LDFLAGS= build
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

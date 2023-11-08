# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 go-module

DESCRIPTION="An open-source Kubernetes security platform."
HOMEPAGE="https://github.com/kubescape/kubescape"
SRC_URI="https://github.com/kubescape/packaging/releases/download/v${PV}/${PN}_${PV}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE=""

BDEPEND=">=dev-lang/go-1.19"
S="${WORKDIR}/deb/${PN}"

src_compile() {
	CGO_ENABLED=1
	cd git2go || die
	# fix script
	sed -i 's#${ROOT-"$(cd "$(dirname "$0")/.." && echo "${PWD}")"}#"$(dirname "$(dirname "$0")")"#' \
		script/build-libgit2.sh
	emake install-static PWD="${WORKDIR}/deb/${PN}/git2go"
	cd .. || die
	cp -r git2go/static-build vendor/github.com/libgit2/git2go/v*/ || die
	ego build -mod=vendor -buildmode=pie -buildvcs=false \
		-ldflags="-s -w -X github.com/${PN}/${PN}/v2/core/cautils.BuildNumber=v${PV}" -tags=static,gitenabled -o ${PN}
}

src_install() {
	dobin ${PN}
	./${PN} completion bash > ${PN}.bash || die
	./${PN} completion zsh > ${PN}.zsh || die
	./${PN} completion zsh > ${PN}.fish || die
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/vendor-completions
	newins ${PN}.zsh _${PN}
	insinto /usr/share/fish/vendor_completions.d/
	newins ${PN}.fish ${PN}.fish
}

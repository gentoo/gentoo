# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fcaps git-r3 golang-build systemd user

GO_PN="github.com/hashicorp/${PN}"

DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"
SRC_URI=""
EGIT_REPO_URI="git://${GO_PN}.git"

SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS=""
IUSE=""

RESTRICT="test"

DEPEND=""
RDEPEND=""

STRIP_MASK="*.a"

S="${WORKDIR}/src/${GO_PN}"

EGIT_CHECKOUT_DIR="${S}"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ei' usr/bin/${PN}
)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	local x

	git-r3_src_unpack

	# Create a writable GOROOT in order to avoid sandbox violations.
	export GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${GO_PN}" || die

	export GOPATH=${WORKDIR}:${WORKDIR}/src/github.com/hashicorp/vault/Godeps/_workspace:$(get_golibdir_gopath)

	while read -r -d '' x; do
		rm -rf "${GOROOT}/src/${x}" "${GOROOT}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}"{,.a} || die
	done < <(find "${WORKDIR}/src/github.com/hashicorp/vault/Godeps/_workspace/src" -maxdepth 3 -mindepth 3 -type d -print0)

	rm -rf "${WORKDIR}/src/github.com/hashicorp/vault/Godeps/_workspace/src/github.com/awslabs"
	go get -d -v -x github.com/awslabs/aws-sdk-go || die

	if ! type -P gox >/dev/null; then
		pushd "${S}" >/dev/null || die
		go get -d -v -x github.com/mitchellh/gox || die
	fi
}

src_compile() {
	go install -v -x github.com/awslabs/aws-sdk-go || die
	if ! type -P gox >/dev/null; then
		go install -v -x github.com/mitchellh/gox || die
	fi
	PATH=${WORKDIR}/bin:${GOROOT}/bin:${PATH} emake dev
}

src_install() {
	local x

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	dobin bin/${PN}

	egit_clean "${WORKDIR}"/{pkg,src}

	find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type f -delete || die

	while read -r -d '' x; do
		x=${x#${WORKDIR}/src}
		[[ -d ${WORKDIR}/pkg/$(go env GOOS)_$(go env GOARCH)/${x} ||
			-f ${WORKDIR}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}.a ]] && continue
		rm -rf "${WORKDIR}"/src/${x}
	done < <(find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type d -print0)
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto "$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${GO_PN%/*}"
	doins -r "${WORKDIR}"/pkg/$(go env GOOS)_$(go env GOARCH)/${GO_PN}
	insinto "$(get_golibdir)/src/${GO_PN%/*}"
	doins -r "${WORKDIR}"/src/${GO_PN}
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fcaps golang-build systemd user

EGO_PN="github.com/hashicorp/${PN}/..."
DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"
SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

DEPEND="dev-go/go-oauth2:="
RDEPEND=""

STRIP_MASK="*.a"

S="${WORKDIR}/${P}"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ei' usr/bin/${PN}
)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	local x

	default
	mv "${S}" "${S}_"
	mkdir -p "$(dirname "${S}/src/${EGO_PN%/*}")" || die
	mv "${S}_" "${S}/src/${EGO_PN%/*}" || die

	# Create a writable GOROOT in order to avoid sandbox violations.
	export GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}"/{src,pkg/$(go env GOOS)_$(go env GOARCH)}/"${EGO_PN%/*}" || die

	export GOPATH=${S}:${S}/src/github.com/hashicorp/vault/Godeps/_workspace:$(get_golibdir_gopath)

	while read -r -d '' x; do
		rm -rf "${GOROOT}/src/${x}" "${GOROOT}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}"{,.a} || die
	done < <(find "${P}/src/github.com/hashicorp/vault/Godeps/_workspace/src" -maxdepth 3 -mindepth 3 -type d -print0)
}

src_compile() {
	go build -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
	go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
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

	dobin "${S}/bin/${PN}"

	find "${S}"/src/${EGO_PN%/*} -mindepth 1 -maxdepth 1 -type f -delete || die

	while read -r -d '' x; do
		x=${x#${S}/src}
		[[ -d ${S}/pkg/$(go env GOOS)_$(go env GOARCH)/${x} ||
			-f ${S}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}.a ]] && continue
		rm -rf "${S}"/src/${x}
	done < <(find "${S}"/src/${EGO_PN%/*} -mindepth 1 -maxdepth 1 -type d -print0)
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto /usr/lib/go/pkg/$(go env GOOS)_$(go env GOARCH)/${GO_PN%/*}
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}
	insinto /usr/lib/go/src/${GO_PN%/*}
	doins -r "${S}"/src/${EGO_PN%/*}
}

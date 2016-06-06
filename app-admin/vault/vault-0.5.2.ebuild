# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fcaps golang-vcs-snapshot systemd user

EGO_PN="github.com/hashicorp/${PN}/..."
DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"
SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

DEPEND=""
RDEPEND=""

STRIP_MASK="*.a"

S="${WORKDIR}/${P}"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ep' usr/bin/${PN}
)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	GOPATH=${S} GO15VENDOREXPERIMENT=1 \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	local x

	dodoc "${S}"/src/${EGO_PN%/*}/{CHANGELOG.md,CONTRIBUTING.md,README.md}
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	dobin "${S}/bin/${PN}"

	rm -rf "${S}"/{src,pkg/$(go env GOOS)_$(go env GOARCH)}/${EGO_PN%/*}/vendor
	find "${S}"/src/${EGO_PN%/*} -mindepth 1 -maxdepth 1 -type f -delete || die

	while read -r -d '' x; do
		x=${x#${S}/src}
		[[ -d ${S}/pkg/$(go env GOOS)_$(go env GOARCH)/${x} ||
			-f ${S}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}.a ]] && continue
		rm -rf "${S}"/src/${x}
	done < <(find "${S}"/src/${EGO_PN%/*} -mindepth 1 -maxdepth 1 -type d -print0)
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto $(dirname "$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}
	insinto $(dirname "$(get_golibdir)/src/${EGO_PN%/*}")
	doins -r "${S}"/src/${EGO_PN%/*}
}

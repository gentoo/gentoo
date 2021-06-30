# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps go-module systemd

DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"
VAULT_WEBUI_ARCHIVE="${P}-webui.tar.xz"
SRC_URI="https://github.com/hashicorp/vault/archive/v${PV}.tar.gz -> ${P}.tar.gz
	webui? (
		https://dev.gentoo.org/~zmedico/dist/${VAULT_WEBUI_ARCHIVE}
	)"

LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+webui"

BDEPEND="dev-go/gox
	>=dev-lang/go-1.15.3"
COMMON_DEPEND="acct-group/vault
	acct-user/vault"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ep' usr/bin/${PN}
)

RESTRICT+=" test"

src_prepare() {
	default
	# Avoid the need to have a git checkout
	sed -e 's:^\(GIT_COMMIT=\).*:\1:' \
		-e 's:^\(GIT_DIRTY=\).*:\1:' \
		-e s:\'\${GIT_COMMIT}\${GIT_DIRTY}\':: \
		-i scripts/build.sh || die
	sed -e "/hooks/d" \
		-e 's|^\([[:space:]]*\)goimports .*)|\1true|' \
		-i Makefile || die
	if [[ -f "${WORKDIR}/http/bindata_assetfs.go" ]]; then
		mv "${WORKDIR}/http/bindata_assetfs.go" "${S}/http" ||
			die "mv failed"
	fi
}

src_compile() {
	mkdir "${T}"/bin || die
	BUILD_TAGS="$(usex webui ui '')" \
	GOFLAGS="-mod=vendor" \
	GOPATH="${T}" \
	XC_ARCH=$(go env GOARCH) \
	XC_OS=$(go env GOOS) \
	XC_OSARCH=$(go env GOOS)/$(go env GOARCH) \
	emake
}

src_install() {
	dobin bin/${PN}
	dodoc CHANGELOG.md CONTRIBUTING.md README.md
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

pkg_postinst() {
	fcaps_pkg_postinst
	go-module_pkg_postinst
}

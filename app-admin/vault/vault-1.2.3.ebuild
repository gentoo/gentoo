# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps golang-base golang-vcs-snapshot systemd user

EGO_PN="github.com/hashicorp/${PN}"
VAULT_WEBUI_ARCHIVE="${P}-webui.tar.xz"
DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	webui? (
		mirror://gentoo/${VAULT_WEBUI_ARCHIVE}
		https://dev.gentoo.org/~zmedico/dist/${VAULT_WEBUI_ARCHIVE}
	)"
SLOT="0"
LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
KEYWORDS="~amd64"
IUSE="+webui"

RESTRICT="test"

DEPEND=">=dev-lang/go-1.12:=
	dev-go/gox"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ep' usr/bin/${PN}
)

src_unpack() {
	golang-vcs-snapshot_src_unpack
	if use webui; then
		# The webui assets build has numerous nodejs dependencies,
		# see https://github.com/hashicorp/vault/blob/master/ui/README.md
		pushd "${S}/src/${EGO_PN}" >/dev/null || die
		unpack "${VAULT_WEBUI_ARCHIVE}"
		popd >/dev/null
	fi
}

src_prepare() {
	default
	# Avoid the need to have a git checkout
	sed -e 's:^\(GIT_COMMIT=\).*:\1:' \
		-e 's:^\(GIT_DIRTY=\).*:\1:' \
		-e s:\'\${GIT_COMMIT}\${GIT_DIRTY}\':: \
		-i src/${EGO_PN}/scripts/build.sh || die
	sed -e "/hooks/d" \
		-e 's|^\([[:space:]]*\)goimports .*)|\1true|' \
		-i src/${EGO_PN}/Makefile || die

	# Avoid network-sandbox violations since go-1.13
	rm src/${EGO_PN}/go.mod || die
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	mkdir bin || die
	export -n GOCACHE XDG_CACHE_HOME #678970
	export GOBIN=${S}/bin GOPATH=${S}
	cd src/${EGO_PN} || die
	# The fmt target may need to be executed if it was previously
	# executed by an older version of go (bug 665438).
	emake fmt
	BUILD_TAGS="$(usex webui ui '')" \
	XC_ARCH=$(go env GOARCH) \
	XC_OS=$(go env GOOS) \
	XC_OSARCH=$(go env GOOS)/$(go env GOARCH) \
	emake
}

src_install() {
	dodoc src/${EGO_PN}/{CHANGELOG.md,CONTRIBUTING.md,README.md}
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	dobin bin/${PN}
}

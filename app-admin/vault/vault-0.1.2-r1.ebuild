# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/vault/vault-0.1.2-r1.ebuild,v 1.1 2015/07/08 19:15:20 williamh Exp $

EAPI=5

inherit fcaps systemd user

KEYWORDS="~amd64"
DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"
GO_PN="github.com/hashicorp/${PN}"
LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.4:=
	dev-go/go-oauth2:="
RDEPEND=""

SRC_URI="https://${GO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/mitchellh/gox/archive/v0.3.0.tar.gz -> gox-0.3.0.tar.gz
https://github.com/mitchellh/iochan/archive/b584a329b193e206025682ae6c10cdbe03b0cd77.tar.gz -> iochan-b584a329b193e206025682ae6c10cdbe03b0cd77.tar.gz"
STRIP_MASK="*.a"
S="${WORKDIR}/src/${GO_PN}"

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
	mkdir -p src/${GO_PN%/*} || die
	mv ${P} src/${GO_PN} || die

	# Create a writable GOROOT in order to avoid sandbox violations.
	export GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${GO_PN}" || die

	export GOPATH=${WORKDIR}:${WORKDIR}/src/github.com/hashicorp/vault/Godeps/_workspace

	while read -r -d '' x; do
		rm -rf "${GOROOT}/src/${x}" "${GOROOT}/pkg/${KERNEL}_${ARCH}/${x}"{,.a} || die
	done < <(find "${WORKDIR}/src/github.com/hashicorp/vault/Godeps/_workspace/src" -maxdepth 3 -mindepth 3 -type d -print0)

	mkdir -p "${GOROOT}/src/github.com/mitchellh" || die
	rm -rf "${GOROOT}/src/github.com/mitchellh/gox" || die
	mv gox-0.3.0 "${GOROOT}/src/github.com/mitchellh/gox" || die
	rm -rf "${GOROOT}/src/github.com/mitchellh/iochan" || die
	mv iochan-* "${GOROOT}/src/github.com/mitchellh/iochan" || die
}

src_prepare() {
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' \
		-e 's:-ldflags.*:\\:' \
		-i scripts/build.sh || die
}

src_compile() {
	go install -v -x github.com/mitchellh/gox || die
	PATH=${GOROOT}/bin:${PATH} emake dev
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
	find "${WORKDIR}"/{pkg,src} -name '.git*' -exec rm -rf {} \; 2>/dev/null
	find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type f -delete
	while read -r -d '' x; do
		x=${x#${WORKDIR}/src}
		[[ -d ${WORKDIR}/pkg/${KERNEL}_${ARCH}/${x} ||
			-f ${WORKDIR}/pkg/${KERNEL}_${ARCH}/${x}.a ]] && continue
		rm -rf "${WORKDIR}"/src/${x}
	done < <(find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type d -print0)
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto /usr/lib/go/pkg/${KERNEL}_${ARCH}/${GO_PN%/*}
	doins -r "${WORKDIR}"/pkg/${KERNEL}_${ARCH}/${GO_PN}
	insinto /usr/lib/go/src/${GO_PN%/*}
	doins -r "${WORKDIR}"/src/${GO_PN}
}

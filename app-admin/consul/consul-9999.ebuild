# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/consul/consul-9999.ebuild,v 1.5 2015/07/08 17:18:10 williamh Exp $

EAPI=5

inherit git-r3 systemd user

KEYWORDS=""
DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="http://www.consul.io"
GO_PN="github.com/hashicorp/consul"
EGIT_REPO_URI="git://${GO_PN}.git"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test web"

DEPEND=">=dev-lang/go-1.4:=
	dev-go/go-crypto:=
	test? ( dev-go/go-tools )
	web? (
		dev-ruby/sass
		dev-ruby/uglifier
	)"
RDEPEND=""
SRC_URI=""

STRIP_MASK="*.a"
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"

pkg_setup() {
	enewgroup consul
	enewuser consul -1 -1 /var/lib/${PN} consul
}

src_unpack() {
	git-r3_src_unpack
	cd "${S}" || die

	# Create a writable GOROOT in order to avoid sandbox violations
	# or other interference from installed instances.
	export GOPATH="${WORKDIR}" GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die

	# Use latest versions of some packages, in case of incompatible
	# API changes
	rm -rf "${GOROOT}/src/${GO_PN%/*}" \
		"${GOROOT}/pkg/linux_${ARCH}/${GO_PN%/*}" || die

	# Fetch dependencies
	emake deps

	# Avoid interference from installed instances
	while read -r path; do
		rm -rf "${GOROOT}/src/${path#${WORKDIR}/src}" \
		"${GOROOT}/pkg/linux_${ARCH}/${path#${WORKDIR}/src}" || die
	done < <(find "${WORKDIR}"/src -maxdepth 3 -mindepth 3 -type d)
}

src_prepare() {
	# Disable tests that fail under network-sandbox
	sed -e 's:TestServer_StartStop:_TestServer_StartStop:' \
		-i consul/server_test.go || die
	sed -e 's:TestRetryJoin(:_TestRetryJoin(:' \
		-i command/agent/command_test.go || die
}

src_compile() {
	emake

	if use web; then
		pushd ui >/dev/null || die
		emake dist
	fi
}

src_install() {
	local x

	dobin bin/*
	rm -rf bin

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners consul:consul "${x}"
	done

	if use web; then
		insinto /var/lib/${PN}/ui
		doins -r ui/dist/*
	fi

	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"
	systemd_dounit "${FILESDIR}/consul.service"

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

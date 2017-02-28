# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

KEYWORDS="~amd64"
EGO_PN="github.com/hashicorp/consul"
DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="http://www.consul.io"
SRC_URI="https://github.com/hashicorp/consul/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/mitchellh/gox/archive/c9740af9c6574448fd48eb30a71f964014c7a837.tar.gz -> gox-c9740af9c6574448fd48eb30a71f964014c7a837.tar.gz
	https://github.com/mitchellh/iochan/archive/87b45ffd0e9581375c491fef3d32130bb15c5bd7.tar.gz -> iochan-87b45ffd0e9581375c491fef3d32130bb15c5bd7.tar.gz
"

SLOT="0"
LICENSE="MPL-2.0"
IUSE=""

RESTRICT="test"

DEPEND="
	>=dev-lang/go-1.7.5:=
	>=dev-go/go-tools-0_pre20160121"
RDEPEND=""

pkg_setup() {
	enewgroup consul
	enewuser consul -1 -1 /var/lib/${PN} consul
}

get_archive_go_package() {
	local archive=${1} uri x
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	echo ${uri%/archive/*}
}

unpack_go_packages() {
	local go_package x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			mkdir -p src/${go_package%/*}
			mv ${go_package##*/}-* src/${go_package} || die
		fi
	done
}

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	unpack_go_packages
}

src_prepare() {
	eapply_user
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' \
		-e 's:-X main.GitCommit.*:" \\:' \
		-i "${S}/src/${EGO_PN}/scripts/build.sh" || die

	# go install golang.org/x/tools/cmd/stringer: mkdir /usr/lib/go-gentoo/bin/: permission denied
	sed -e 's:go get -u -v $(GOTOOLS)::' \
		-i "${S}/src/${EGO_PN}/GNUmakefile" || die
}

src_compile() {
	export GOPATH="${S}"
	go install -v -work -x ${EGO_BUILD_FLAGS} "github.com/mitchellh/gox/..." || die
	# The dev target sets causes build.sh to set appropriate XC_OS
	# and XC_ARCH, and skips generation of an unused zip file,
	# avoiding a dependency on app-arch/zip.
	PATH=${PATH}:${S}/bin \
		emake -C "${S}/src/${EGO_PN}" dev
}

src_install() {
	local x

	dobin "${S}/bin/${PN}"

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners consul:consul "${x}"
	done

	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/consul.service"
}

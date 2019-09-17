# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/mitchellh/gox c9740af9c6574448fd48eb30a71f964014c7a837"
	"github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7"
)

inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
EGO_PN="github.com/hashicorp/serf"
DESCRIPTION="Service orchestration and management tool"
HOMEPAGE="https://www.serfdom.io/"
SRC_URI="https://github.com/hashicorp/serf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

SLOT="0"
LICENSE="MPL-2.0 Apache-2.0 BSD MIT"
IUSE=""
RESTRICT="test"

DEPEND="
	>=dev-lang/go-1.6:=
	>=dev-go/go-tools-0_pre20160121"
RDEPEND=""

pkg_setup() {
	enewgroup serf
	enewuser serf -1 -1 /var/lib/${PN} serf
}

src_prepare() {
	eapply_user
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' \
		-e 's:-X main.GitCommit.*:" \\:' \
		-i "${S}/src/${EGO_PN}/scripts/build.sh" || die

	# go install golang.org/x/tools/cmd/stringer: mkdir /usr/lib/go-gentoo/bin/: permission denied
	sed -e 's:go get -u -v $(GOTOOLS)::' \
		-e 's:^GIT.*::' \
		-i "${S}/src/${EGO_PN}/GNUmakefile" || die
}

src_compile() {
	export GOPATH="${S}"
	mkdir "${S}/src/github.com/mitchellh" || die
	mv "${S}/src/${EGO_PN}/vendor/github.com/mitchellh/"{gox,iochan} \
		"${S}/src/github.com/mitchellh" || die
	go install -v -work -x ${EGO_BUILD_FLAGS} "github.com/mitchellh/gox/..." || die
	# The dev target sets causes build.sh to set appropriate XC_OS
	# and XC_ARCH, and skips generation of an unused zip file,
	# avoiding a dependency on app-arch/zip.
	PATH=${PATH}:${S}/bin \
		emake -C "${S}/src/${EGO_PN}" dev
}

src_test() {
	emake -C "${S}/src/${EGO_PN}" test
}

src_install() {
	local x

	dobin "${S}/bin/${PN}"

	keepdir /etc/serf.d
	insinto /etc/serf.d

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners serf:serf "${x}"
	done

	newinitd "${FILESDIR}/serf.initd" "${PN}"
	newconfd "${FILESDIR}/serf.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/serf.service"
}

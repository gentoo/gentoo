# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd tmpfiles
GIT_COMMIT=5e7fd0de9

DESCRIPTION="Highly-available key value store for shared configuration and service discovery"
HOMEPAGE="https://github.com/etcd-io/etcd"
SRC_URI="https://github.com/etcd-io/etcd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~chewi/distfiles/${P}-vendor.tar.xz"

# `go mod vendor` doesn't work but `go work vendor` does. Additional steps can
# make the vendor tarball a bit smaller.
#
# P=etcd-3.X.Y
# ebuild ${P}.ebuild clean unpack
# cd /var/tmp/portage/dev-db/${P}/work/${P}
# sed -i "/\.\/tools\//d" go.work
# go work vendor
# tar --owner root --group root -Jcf /var/cache/distfiles/${P}-vendor.tar.xz -C .. ${P}/vendor ${P}/go.work

LICENSE="Apache-2.0"
LICENSE+=" BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
IUSE="doc +server"

COMMON_DEPEND="server? (
	acct-group/etcd
	acct-user/etcd
	)"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND=">=dev-lang/go-1.26"

# Unit tests attempt to download go modules.
PROPERTIES="test_network"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-3.7.1-vendor.patch
)

src_prepare() {
	default
	sed -i "s|GIT_SHA=.*|GIT_SHA=${GIT_COMMIT}|" scripts/build_lib.sh || die

	# Don't test these as they are not built.
	find tools/ -name "*_test.go" -delete || die
}

src_configure() {
	export FORCE_HOST_GO=1 GO_BUILD_FLAGS="-v -x"
}

src_compile() {
	scripts/build.sh || die
}

src_test() {
	# -buildmode=pie is incompatible with -race used by the tests.
	GOFLAGS=${GOFLAGS//-buildmode=pie} PASSES="unit" scripts/test.sh -v || die
}

src_install() {
	dobin bin/etcdctl
	dobin bin/etcdutl
	use doc && dodoc -r Documentation
	if use server; then
		insinto /etc/${PN}
		sed -e 's|^data-dir:|\0 /var/lib/etcd|' -i etcd.conf.yml.sample || die
		newins etcd.conf.yml.sample etcd.conf.yml
		dobin bin/etcd
		dodoc README.md
		systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"
		newtmpfiles "${FILESDIR}/${PN}.tmpfiles.d.conf" ${PN}.conf
		newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
		newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotated" "${PN}"
		keepdir /var/lib/${PN} /var/log/${PN}
		fowners ${PN}:${PN} /var/lib/${PN} /var/log/${PN}
		fperms 0700 /var/lib/${PN}
		fperms 0755 /var/log/${PN}
	fi
}

pkg_postinst() {
	if use server; then
		tmpfiles_process ${PN}.conf
	fi
}

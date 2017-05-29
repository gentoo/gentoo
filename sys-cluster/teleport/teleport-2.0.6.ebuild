# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user eutils golang-build systemd

DESCRIPTION="Modern SSH server for teams managing distributed infrastructure"
HOMEPAGE="https://gravitational.com/teleport"

EGO_PN="github.com/gravitational/${PN}/..."

if [ ${PV} == "9999" ] ; then
	inherit git-r3 golang-vcs
	EGIT_REPO_URI="https://github.com/gravitational/${PN}.git"
else
	inherit golang-vcs-snapshot
	SRC_URI="https://github.com/gravitational/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="etcd systemd"

DEPEND=">=dev-lang/go-1.7 app-arch/zip"
RDEPEND="
	systemd? ( sys-apps/systemd )
	etcd? ( dev-db/etcd )"

src_prepare() {
	default

	for i in "${FILESDIR}"/*;do cp "$i" "${S}";done

	if use etcd; then
		epatch "${S}/${PN}-etcd-storage-backend.patch"
		epatch "${S}/${PN}-init-d-etcd.patch"
		epatch "${S}/${PN}-systemd-etcd.patch"
	fi
}

src_compile() {
	GOPATH="${S}" emake -C src/${EGO_PN%/*}
	pushd src/${EGO_PN%/*}/web/dist
	zip -qr "${S}/src/${EGO_PN%/*}/build/webassets.zip" . || die "failed to create webassets.zip"
	popd
	cat "${S}/src/${EGO_PN%/*}/build/webassets.zip" >> "src/${EGO_PN%/*}/build/${PN}"
	zip -q -A "${S}/src/${EGO_PN%/*}/build/teleport"
}

src_install() {
	dodir /var/lib/${PN} /etc/${PN}
	pushd src/${EGO_PN%/*} || die
	dobin build/{tsh,tctl,teleport}
	popd

	insinto /etc/${PN}
	doins ${PN}.yaml

	newinitd ${PN}.init.d ${PN}

	use systemd && systemd_dounit ${PN}.service
}

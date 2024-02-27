# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="
	amd64? (
		elibc_glibc? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-x64.tar.gz )
		elibc_musl? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-musl-core-x64.tar.gz )
	)
	arm? (
		elibc_glibc? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-arm.tar.gz )
		elibc_musl? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-musl-core-arm.tar.gz )
	)
	arm64? (
		elibc_glibc? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-arm64.tar.gz )
		elibc_musl? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-musl-core-arm64.tar.gz )
	)
"

DESCRIPTION="An ebook and audiobook collection manager for Usenet and BitTorrent users"
HOMEPAGE="https://readarr.com/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/readarr
	acct-user/readarr
	dev-libs/icu
	dev-util/lttng-ust:0
	dev-db/sqlite
	sys-libs/glibc
"

QA_PREBUILT="*"

S="${WORKDIR}/Readarr"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Readarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/opt/${PN}"
	cp -R "${S}/." "${D}/opt/readarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/readarr.service"
	systemd_newunit "${FILESDIR}/readarr.service" "${PN}@.service"
}

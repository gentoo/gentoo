# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="An ebook and audiobook collection manager for Usenet and BitTorrent users"
HOMEPAGE="https://readarr.com/
	https://github.com/Readarr/Readarr/"

SRC_URI="
	amd64? (
		elibc_glibc? (
			https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-x64.tar.gz
		)
		elibc_musl? (
			https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-musl-core-x64.tar.gz
		)
	)
	arm? (
		elibc_glibc? (
			https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-arm.tar.gz
		)
		elibc_musl? (
			https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-musl-core-arm.tar.gz
		)
	)
	arm64? (
		elibc_glibc? (
			https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-arm64.tar.gz
		)
		elibc_musl? (
			https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-musl-core-arm64.tar.gz
		)
	)
"
S="${WORKDIR}/Readarr"

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
"

QA_PREBUILT="*"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Readarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/readarr.init" readarr

	keepdir /var/lib/readarr
	fowners -R readarr:readarr /var/lib/readarr

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/readarr.logrotate" readarr

	dodir  "/opt/readarr"
	cp -R "${S}/." "${D}/opt/readarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/readarr.service"
	systemd_newunit "${FILESDIR}/readarr.service" "readarr@.service"
}

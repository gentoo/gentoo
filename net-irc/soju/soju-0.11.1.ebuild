# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-env go-module systemd tmpfiles verify-sig

DESCRIPTION="soju is a user-friendly IRC bouncer"
HOMEPAGE="https://soju.im/"
SRC_URI="https://codeberg.org/emersion/${PN}/releases/download/v${PV}/${P}.tar.gz -> ${P}.cb.tar.gz
	https://codeberg.org/emersion/${PN}/releases/download/v${PV}/${P}.tar.gz.sig -> ${P}.cb.tar.gz.sig"
SRC_URI+=" https://github.com/gentoo-golang-dist/soju/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="AGPL-3 Apache-2.0 MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"
IUSE="moderncsqlite +sqlite pam"
REQUIRED_USE="?? ( moderncsqlite sqlite )"

BDEPEND="
	app-text/scdoc
	verify-sig? ( sec-keys/openpgp-keys-emersion )
"
RDEPEND="
	acct-user/soju
	acct-group/soju
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}.cb.tar.gz{,.sig}
	default
}

format_tags() {
	local IFS=,
	echo "${tags[*]}"
}

src_configure() {
	# Note: we skip this in src_unpack
	go-env_set_compile_environment

	# musl removed legacy LFS64 interfaces in version 1.2.4 temporarily
	# reenabled using _LARGEFILE64_SOURCE until this is resolved
	# upstream https://github.com/mattn/go-sqlite3/issues/1164
	CGO_CFLAGS="${CGO_CFLAGS}"
	local tags=()
	if use sqlite; then
		tags+=( libsqlite3 )
		CGO_CFLAGS+=" -D_LARGEFILE64_SOURCE"
	elif use moderncsqlite; then
		tags+=( moderncsqlite )
		CGO_CFLAGS+=" -D_LARGEFILE64_SOURCE"
	else
		tags+=( nosqlite )
	fi
	# Only way to pass CFLAGS to CGO at the
	# moment. https://github.com/gentoo/gentoo/pull/33539/
	export CGO_CFLAGS
	use pam && tags+=( pam )
	export GOFLAGS+=" -tags=$(format_tags)"
	export PREFIX="${EPREFIX}/usr"
	export SYSCONFDIR="${EPREFIX}/etc"
	export RUNDIR="${EPREFIX}/run"
}

src_install() {
	emake DESTDIR="${D}" install
	rmdir "${D}"/var{/lib{/soju,},} || die # Remove empty directories
	systemd_dounit contrib/soju.service
	newtmpfiles "${FILESDIR}/soju.tmpfiles" soju.conf
	newinitd "${FILESDIR}"/soju.initd soju
	einstalldocs
}

pkg_postinst() {
	tmpfiles_process soju.conf

	elog "${PN} requires a user database for authenticating clients."
	elog "As the soju user, create a database using:"
	elog "$ sojudb -config ${EROOT}/etc/soju/config create-user <username> [-admin]"
}

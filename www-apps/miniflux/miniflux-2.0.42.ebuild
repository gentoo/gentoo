# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Minimalist and opinionated feed reader"
HOMEPAGE="https://miniflux.app https://github.com/miniflux/v2"
SRC_URI="https://github.com/${PN}/v2/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ppc64 ~riscv"

RESTRICT="test" # requires network access

DEPEND="acct-user/miniflux"
RDEPEND="${DEPEND}
	>=dev-db/postgresql-9.5
"

S="${WORKDIR}/v2-${PV}"

src_compile() {
	ego build -ldflags="-s -w -X 'miniflux.app/version.Version=${PV}' " -o miniflux main.go
}

src_install() {
	dobin miniflux

	insinto /etc
	doins "${FILESDIR}/${PN}.conf"

	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"

	fowners miniflux:root /etc/${PN}.conf
	fperms o-rwx /etc/${PN}.conf

	local DOCS=(
		ChangeLog
		README.md
		"${FILESDIR}"/README.gentoo
	)

	# Makefile has no install target, so call einstalldocs directly
	einstalldocs

	doman "${PN}".1
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation

		echo
		elog "Before using miniflux, you must first create and initialize the database"
		elog "and enable the hstore extension for it."
		elog ""
		elog "Afterwards, create your first admin user by running:"
		elog "  miniflux -create-admin"
	else
		# This is an existing installation

		echo
		elog "If you are upgrading from a previous version, schema migrations must be performed."
		elog "To perform the migrations, stop the daemon, backup your database, and run:"
		elog "  emerge --config =${PF}"
	fi

	echo
	elog "Please read"
	elog ""
	elog "  ${EPREFIX}/usr/share/doc/${PF}/README.gentoo*"
	elog ""
	elog "for more information."
}

pkg_config() {
	# To be safe, avoid doing migrations if miniflux is running
	if pgrep miniflux; then
		die "miniflux appears to be running, refusing to continue."
	fi

	# Extract the database URL variable instead of just sourcing the config file
	# because miniflux itself may interpret quotes as part of the URL
	local DATABASE_URL="$(sed -n 's/^DATABASE_URL=\(.*\)/\1/p' "${EROOT}/etc/${PN}.conf")"
	[[ -n "${DATABASE_URL}" ]] || die "Failed getting DATABASE_URL from config file"

	DATABASE_URL="${DATABASE_URL}" "${EROOT}"/usr/bin/miniflux -migrate \
		|| die "miniflux -migrate failed. Please check the above output for errors."

	echo
	elog "Database migrations complete."
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Default Akonadi storage backend configuration"
HOMEPAGE="https://userbase.kde.org/Tutorials/Shared_Database#Akonadi"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="+mysql postgres sqlite"

REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="
	!<kde-apps/akonadi-24.11.80
	dev-qt/qtbase:6[mysql?,postgres?,sqlite?]
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
"

pkg_pretend() {
	if [[ -n "${REPLACING_VERSIONS}" ]] || ! has_version "kde-apps/akonadi"; then
		return
	fi
	for backend in sqlite postgres mysql; do
		if ! use ${backend} && has_version "kde-apps/akonadi[${backend}]"; then
			ewarn "Potential upgrade issue detected!"
			ewarn "Previously: kde-apps/akonadi[${backend}] *** enabled ***"
			ewarn "Now: kde-apps/akonadi-config[${backend}] *** disabled ***"
			ewarn "Make sure any Akonadi user storage backends in ~/.config/akonadi/akonadiserverrc"
			ewarn "have been migrated accordingly. To migrate an existing backend to a different"
			ewarn "driver, run \`akonadi-db-migrator --newengine sqlite|mysql|postgres\`"
			ewarn "To succeed, both drivers need to be enabled in dev-qt/qtbase USE - it is *not*"
			ewarn "necessary to downgrade kde-apps/akonadi if you learn about this after upgrading."
		fi
	done
}

pkg_setup() {
	# Set default storage backend in order: MySQL, SQLite, PostgreSQL
	# reverse driver check to keep the order
	use postgres && DRIVER="QPSQL"
	use sqlite && DRIVER="QSQLITE"
	use mysql && DRIVER="QMYSQL"
}

src_unpack() { :; }
src_configure() { :; }
src_compile() { :; }

src_install() {
	# Who knows, maybe it accidentally fixes our permission issues
	cat <<-EOF > "${T}"/akonadiserverrc || die
		[%General]
		Driver=${DRIVER}
	EOF
	insinto /usr/share/config/akonadi
	doins "${T}"/akonadiserverrc
}

pkg_postinst() {
	elog "You can select the storage backend in ~/.config/akonadi/akonadiserverrc."
	elog "Available drivers (by enabled USE flags) are:"
	use mysql && elog "  QMYSQL"
	use sqlite && elog "  QSQLITE"
	use postgres && elog "  QPSQL"
	elog "${DRIVER} has been set as your default akonadi storage backend."
	elog
	optfeature_header "The following optional database backends exist:"
	optfeature "SQLite backend support" "${CATEGORY}/${PN}[sqlite]"
	optfeature "MySQL backend support" "${CATEGORY}/${PN}[mysql]"
	optfeature "PostgreSQL backend support" "${CATEGORY}/${PN}[postgres]"
}

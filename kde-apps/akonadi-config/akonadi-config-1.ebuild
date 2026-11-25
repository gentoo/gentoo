# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Default Akonadi storage backend configuration"
HOMEPAGE="https://userbase.kde.org/Tutorials/Shared_Database#Akonadi"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="mysql postgres +sqlite"

REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="
	!<kde-apps/akonadi-24.11.80
	dev-qt/qtbase:6[mysql?,postgres?,sqlite?]
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
"

pkg_pretend() {
	local backend backends=() oldbackend package
	use sqlite && backends+=( sqlite )
	use mysql && backends+=( mysql )
	use postgres && backends+=( postgres )

	for package in kde-apps/akonadi ${CATEGORY}/${PN}; do
		if ! has_version "${package}"; then
			continue
		fi
		for oldbackend in mysql postgres sqlite; do
			if ! use ${oldbackend} && has_version "${package}[${oldbackend}]"; then
				ewarn "Potential upgrade issue detected!"
				ewarn "Previously: ${package}[${oldbackend}]  *** enabled ***"
				ewarn "Now:        ${CATEGORY}/${PN}[-${oldbackend}] *** disabled ***"
				ewarn "Make sure any Akonadi user storage backends in ~/.config/akonadi/akonadiserverrc"
				ewarn "have been migrated accordingly by running once, as regular user:"
				ewarn
				for backend in "${backends[@]}" ; do
					ewarn "    akonadi-db-migrator --newengine ${backend}"
				done
				ewarn
				ewarn "To succeed, both old and new backend drivers need to be enabled as dev-qt/qtbase"
				ewarn "USE flags - it is *not* necessary to downgrade ${package} if you"
				ewarn "learn about this after upgrading."
			fi
		done
	done
}

pkg_setup() {
	# Set default storage backend in order: SQLite, MySQL, PostgreSQL
	# reverse driver check to keep the order
	use postgres && AKONADI_CONFIG_DRIVER="QPSQL"
	use mysql && AKONADI_CONFIG_DRIVER="QMYSQL"
	use sqlite && AKONADI_CONFIG_DRIVER="QSQLITE"
}

src_unpack() { :; }
src_configure() { :; }
src_compile() { :; }

src_install() {
	# Who knows, maybe it accidentally fixes our permission issues
	cat <<-EOF > "${T}"/akonadiserverrc || die
		[%General]
		Driver=${AKONADI_CONFIG_DRIVER}
	EOF
	insinto /usr/share/config/akonadi
	doins "${T}"/akonadiserverrc
}

pkg_postinst() {
	elog "You can select the storage backend in ~/.config/akonadi/akonadiserverrc."
	elog "Available drivers (by enabled USE flags) are:"
	use sqlite && elog "  QSQLITE"
	use mysql && elog "  QMYSQL"
	use postgres && elog "  QPSQL"
	elog "${AKONADI_CONFIG_DRIVER} has been set as your default akonadi storage backend."
	elog
	optfeature_header "The following optional database backends exist:"
	optfeature "SQLite backend support" "${CATEGORY}/${PN}[sqlite]"
	optfeature "MySQL backend support" "${CATEGORY}/${PN}[mysql]"
	optfeature "PostgreSQL backend support" "${CATEGORY}/${PN}[postgres]"
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Icinga Web 2 plugin for configuration"
HOMEPAGE="https://github.com/Icinga/icingaweb2-module-director/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Icinga/${PN}.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://codeload.github.com/Icinga/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
# Dependencies according to https://github.com/Icinga/icingaweb2-module-director/blob/master/doc/02-Installation.md
IUSE="php_targets_php8-1"

PHP_DEPEND="
	php_targets_php8-1? ( dev-lang/php:8.1[curl,iconv,pcntl,posix,sockets] )
"
DEPEND="
	acct-group/icingaweb2
	acct-user/icingadirector
"
RDEPEND="
	${PHP_DEPEND}
	${DEPEND}
	>=www-apps/icingaweb2-module-incubator-0.18.0
	>=dev-libs/icinga-php-library-0.5.0
	>=dev-libs/icinga-php-thirdparty-0.9.0
	>=www-apps/icingaweb2-2.9.0
"

src_install() {
	insinto /usr/share/icingaweb2/modules/${PN##*-}/
	doins -r .

	exeinto /usr/share/icingaweb2/bin/
	doexe "${FILESDIR}"/icinga-director.sh

	doinitd "${FILESDIR}"/director

	keepdir /var/lib/${PN}
	fowners icingadirector:icingaweb2 /var/lib/${PN}
	fperms 0750 /var/lib/${PN}
	sed -e "s|/usr/bin/icingacli|/usr/share/icingaweb2/bin/icingacli|g" \
		contrib/systemd/icinga-director.service > "${T}"/icinga-director.service \
		|| die "failed to patch icinga-director.service"
	systemd_dounit "${T}"/icinga-director.service
}

pkg_postinst() {
	# According to PMS this can be a space-separated list of version
	# numbers, even though in practice it is typically just one.
	local oldver
	for oldver in ${REPLACING_VERSIONS}; do
		if ver_test "${oldver}" -lt "1.10.0"; then
			ewarn "You are upgrading from ${oldver} to ${PVR}"
			ewarn "please read https://github.com/Icinga/icingaweb2-module-director/blob/master/doc/05-Upgrading.md#upgrade-to-1.10.x"
			ewarn "for breaking changes"
			ewarn
			ewarn "Also, don't forget to upgrade database schema."
			ewarn "Otherwise icingaweb2-module-director will not work!"
			ewarn "(Web GUI => Configuration => Modules => director => Configuration)"
			ewarn
			break
		fi
	done
}

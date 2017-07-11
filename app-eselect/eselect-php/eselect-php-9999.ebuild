# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd git-r3 autotools

DESCRIPTION="PHP eselect module"
HOMEPAGE="https://gitweb.gentoo.org/proj/eselect-php.git/"
EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/eselect-php.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="fpm apache2"

# The "DirectoryIndex" line in 70_mod_php.conf requires mod_dir.
RDEPEND="app-admin/eselect
	sys-apps/gentoo-functions
	apache2? ( www-servers/apache[apache2_modules_dir] )"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure(){
	# We expect localstatedir to be "var"ish, not "var/lib"ish, because
	# that's what PHP upstream expects. See for example the FPM
	# configuration where they put logs in @localstatedir@/log.
	econf --localstatedir="${EPREFIX}"/var $(use_enable apache2)
}

src_install() {
	default
	[[ -f "${D}/etc/init.d/php-fpm.example.init" ]] && rm "${D}/etc/init.d/php-fpm.example.init" || die
	# This can be removed after a while...
	if use apache2 ; then
		insinto /etc/apache2/modules.d
		newins "${FILESDIR}/70_mod_php5.backcompat.conf" 70_mod_php5.conf
	fi

	if use fpm ; then
		newinitd "doc/php-fpm.example.init" "php-fpm"
		newconfd "doc/php-fpm.example.conf" "php-fpm"
		systemd_dotmpfilesd "${FILESDIR}/php-fpm.conf"
		exeinto /usr/libexec
		newexe "${FILESDIR}/php-fpm-launcher-r1" php-fpm-launcher
	fi
}

pkg_postinst() {
	if use apache2 ; then
		elog
		elog "If you are upgrading, be warned that our mod_php configuration"
		elog "file has changed! You should now define -DPHP for the apache2"
		elog "daemon, and inspect the new 70_mod_php.conf which has been"
		elog "installed. Module loading involves eselect as of this version."
		elog
		elog "You must run eselect at least once to choose your apache2 target"
		elog "before the new configuration will work. Afterwards, and after you"
		elog "have reviewed your new configuration, you are advised to remove"
		elog "the obsolete 70_mod_php5.conf file."
		elog
	fi
}

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
	apache2? ( www-servers/apache[apache2_modules_dir] )
	fpm? ( sys-apps/gentoo-functions )"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure(){
	# We expect localstatedir to be "var"ish, not "var/lib"ish, because
	# that's what PHP upstream expects. See for example the FPM
	# configuration where they put logs in @localstatedir@/log.
	#
	# The libdir is passed explicitly in case the /usr/lib symlink
	# is not present (bug 624528).
	econf --libdir="${EPREFIX}/usr/$(get_libdir)" \
		  --localstatedir="${EPREFIX}/var" \
		  --with-piddir="${EPREFIX}/run" \
		  $(use_enable apache2) \
		  $(use_enable fpm)
}

src_install() {
	default

	# This can be removed after a while...
	if use apache2 ; then
		insinto /etc/apache2/modules.d
		newins "${FILESDIR}/70_mod_php5.backcompat.conf" 70_mod_php5.conf
	fi

	if use fpm ; then
		systemd_dotmpfilesd "${FILESDIR}/php-fpm.conf"
		exeinto /usr/libexec
		newexe "${FILESDIR}/php-fpm-launcher-r2" php-fpm-launcher
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

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="PHP eselect module"
HOMEPAGE="https://gitweb.gentoo.org/proj/eselect-php.git/"
SRC_URI="https://dev.gentoo.org/~mjo/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="fpm apache2"

# The "DirectoryIndex" line in 70_mod_php.conf requires mod_dir.
RDEPEND="app-admin/eselect
	apache2? ( www-servers/apache[apache2_modules_dir] )"

src_configure() {
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

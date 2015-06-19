# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mail-notification/mail-notification-5.4-r8.ebuild,v 1.3 2014/12/28 12:04:44 ago Exp $

EAPI=5
GCONF_DEBUG="no"

inherit gnome2 eutils multilib flag-o-matic toolchain-funcs

DESCRIPTION="Status icon informing about new mail"
HOMEPAGE="http://www.nongnu.org/mailnotify/ https://github.com/epienbroek/mail-notification"

GIT_REVISION="eab5c13" # Same as Fedora
SRC_URI="https://github.com/epienbroek/${PN}/tarball/${GIT_REVISION} -> ${PN}-${GIT_REVISION}.tar.gz"
S="${WORKDIR}/epienbroek-${PN}-${GIT_REVISION}"

KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-linux"
SLOT="0"
LICENSE="GPL-3"
IUSE="+gnome-keyring sasl +sound ssl sylpheed"

LANGS="bg ca cs de es fr ja nl pl pt pt_BR ru sr sr@Latn sv"
for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

# gmime is actually optional, but it's used by so much of the package
# it's pointless making it optional. gnome-keyring is required for
# several specific access methods, and thus linked to those USE flags
# instead of adding a keyring USE flag.
RDEPEND="
	x11-libs/gtk+:3
	>=dev-libs/glib-2.14:2
	>=gnome-base/gconf-2.6
	>=gnome-base/libgnomeui-2.14
	dev-libs/dbus-glib
	dev-libs/gmime:2.6
	>=x11-libs/libnotify-0.4.1
	gnome-keyring? ( gnome-base/libgnome-keyring )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	sound? ( media-libs/gstreamer:0.10 )
	sylpheed? ( mail-client/sylpheed )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	dev-util/gob
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0
"
# this now uses JB (the Jean-Yves Lefort's Build System) as a build system
# instead of autotools, this is a little helper function that basically does
# the same thing as use_enable
use_var() {
	echo "${2:-$1}=$(usex $1)"
}

src_prepare() {
	sed -i	-e '/jb_rule_set_install_message/d' \
		-e '/jb_rule_add_install_command/d' \
		jbsrc/jb.c || die

	# Ensure we never append -Werror
	sed -i -e 's/ -Werror//' jb jbsrc/jb.c || die

	# We are not Ubuntu, and this could be the cause of #215281
	epatch "${FILESDIR}/${P}-remove-ubuntu-special-case.patch"

	# Apply Fedora patches
	# Fix gcc warning
	epatch "${FILESDIR}/${PN}-jb-gcc-format.patch"
	# Support aarch64
	epatch "${FILESDIR}/${PN}-aarch64.patch"
	# Fix build with latest libc
	epatch "${FILESDIR}/${PN}-dont-link-against-bsd-compat.patch"
}

src_configure() {
	set -- \
	./jb configure destdir="${D}" prefix="${EPREFIX}/usr" libdir="${EPREFIX}/usr/$(get_libdir)" \
		sysconfdir="${EPREFIX}/etc" localstatedir="${EPREFIX}/var" cc="$(tc-getCC)" \
		cflags="${CFLAGS}" cppflags="${CXXFLAGS}" ldflags="${LDFLAGS}" \
		scrollkeeper-dir="${EPREFIX}/var/lib/scrollkeeper" \
		$(use_var gnome-keyring gmail) \
		$(use_var gnome-keyring imap) \
		$(use_var gnome-keyring pop3) \
		$(use_var sasl) \
		$(use_var ssl) \
		$(use_var sylpheed)
	echo "$@"
	"$@" || die
}

src_compile() {
	./jb build || die
}

src_install() {
	GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1" ./jb install || die
	dodoc NEWS README AUTHORS TODO TRANSLATING
	rm -rf "${ED}/var/lib/scrollkeeper"

	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		use "linguas_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${D}"/usr/share/locale/"${lang}" || die
	done
}

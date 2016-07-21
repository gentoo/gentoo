# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Note: xemacs currently does not work with a hardened profile. If you
# want to use xemacs on a hardened profile then compile with the
# -nopie flag in CFLAGS or help fix bug #75028.

EAPI=4

WANT_AUTOCONF="2.5"
inherit eutils flag-o-matic multilib

DESCRIPTION="highly customizable open source text editor and application development system"
HOMEPAGE="http://www.xemacs.org/"
SRC_URI="http://ftp.xemacs.org/xemacs-21.5/${P}.tar.gz
	http://www.malfunction.de/afterstep/files/NeXT_XEmacs.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="alsa debug eolconv gif gpm pop postgres ldap libressl xface nas dnd X jpeg tiff png mule motif freewnn canna xft xim athena neXt Xaw3d gdbm berkdb"

X_DEPEND="x11-libs/libXt x11-libs/libXmu x11-libs/libXext x11-misc/xbitmaps"

RDEPEND="
	berkdb? ( >=sys-libs/db-4 !!<sys-libs/db-4 )
	gdbm? ( >=sys-libs/gdbm-1.8.3[berkdb(+)] )
	>=sys-libs/zlib-1.1.4
	!libressl? ( >=dev-libs/openssl-0.9.6:0 )
	libressl? ( dev-libs/libressl )
	>=media-libs/audiofile-0.2.3
	gpm? ( >=sys-libs/gpm-1.19.6 )
	postgres? ( dev-db/postgresql )
	ldap? ( net-nds/openldap )
	alsa? ( media-libs/alsa-lib )
	nas? ( media-libs/nas )
	X? ( $X_DEPEND !Xaw3d? ( !neXt? ( x11-libs/libXaw ) ) )
	dnd? ( x11-libs/dnd )
	motif? ( >=x11-libs/motif-2.3:0[xft=] )
	athena? ( x11-libs/libXaw )
	Xaw3d? ( x11-libs/libXaw3d )
	xft? ( media-libs/freetype:2 x11-libs/libXft x11-libs/libXrender >=media-libs/fontconfig-2.5.0 )
	neXt? ( x11-libs/neXtaw )
	xface? ( media-libs/compface )
	tiff? ( media-libs/tiff:0 )
	png? ( >=media-libs/libpng-1.2:0 )
	jpeg? ( virtual/jpeg:0 )
	canna? ( app-i18n/canna )
	freewnn? ( app-i18n/freewnn )
	>=sys-libs/ncurses-5.2
	>=app-eselect/eselect-emacs-1.15"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PDEPEND="app-xemacs/xemacs-base
	mule? ( app-xemacs/mule-base )"

src_unpack() {
	default_src_unpack

	use neXt && unpack NeXT_XEmacs.tar.gz
}

src_prepare() {
	use neXt && cp "${WORKDIR}"/NeXT.XEmacs/xemacs-icons/* "${S}"/etc/toolbar/
	find "${S}"/lisp -name '*.elc' -exec rm {} \; || die
	epatch "${FILESDIR}/${P}-ncurses-tinfo.patch"

	# Some binaries and man pages are installed under suffixed names
	# to avoid collions with their GNU Emacs counterparts (see below).
	# Fix internal filename references.
	sed -i -e 's/exec gnuclient/&-xemacs/' lib-src/gnudoit || die
	sed -i -e '/^\.so/s/etags/&-xemacs/' etc/ctags.1 || die
	sed -i -e '/^\.so/s/gnuserv/&-xemacs/' etc/gnu{client,doit,attach}.1 || die
}

src_configure() {
	local myconf=""

	if use X; then

		myconf="${myconf} --with-widgets=athena"
		myconf="${myconf} --with-dialogs=athena"
		myconf="${myconf} --with-menubars=lucid"
		myconf="${myconf} --with-scrollbars=lucid"
		if use motif ; then
			myconf="--with-widgets=motif"
			myconf="${myconf} --with-dialogs=motif"
			myconf="${myconf} --with-scrollbars=motif"
			myconf="${myconf} --with-menubars=lucid"
		fi
		if use athena or use Xaw3d ; then
			myconf="--with-scrollbars=athena"
		fi

		if use Xaw3d; then
			myconf="${myconf} --with-athena=3d"
		elif use neXt; then
			myconf="${myconf} --with-athena=next"
		else
			myconf="${myconf} --with-athena=xaw"
		fi

		use dnd && myconf="${myconf} --with-dragndrop --with-offix"

		myconf="${myconf} $(use_with tiff )"
		myconf="${myconf} $(use_with png )"
		myconf="${myconf} $(use_with jpeg )"
		myconf="${myconf} $(use_with xface )"

		use xft && myconf="${myconf} --with-xft=emacs,tabs,menubars,gauges" ||
			myconf="${myconf} --with-xft=no"

	else
		myconf="${myconf}
			--without-x
			--without-xpm
			--without-dragndrop
			--with-xft=no
			--with-gif=no"
	fi

	if use mule ; then
		myconf="${myconf} --with-mule"

		if use xim ; then
			if use motif ; then
				myconf="${myconf} --with-xim=motif"
			else
				myconf="${myconf} --with-xim=xlib"
			fi
		else
			myconf="${myconf} --with-xim=no"
		fi

		myconf="${myconf} $(use_with canna )"
		myconf="${myconf} $(use_with freewnn wnn )"
	fi

	# This determines the type of sounds we are playing
	local soundconf="native"

	# This determines how these sounds should be played
	use nas	&& soundconf="${soundconf},nas"
	use alsa && soundconf="${soundconf},alsa"

	myconf="${myconf} --with-sound=${soundconf}"

	if use gdbm || use berkdb ; then
		use gdbm   && mydb="gdbm"
		use berkdb && mydb="${mydb},berkdb"

		myconf="${myconf} --with-database=${mydb}"
	else
		myconf="${myconf} --without-database"
	fi

	use debug && myconf="${myconf} --with-debug" ||
		myconf="${myconf} --with-optimization"

	econf ${myconf} \
		$(use_with gif ) \
		$(use_with gpm ) \
		$(use_with postgres postgresql ) \
		$(use_with ldap ) \
		$(use_with eolconv file-coding ) \
		$(use_with pop ) \
		--prefix=/usr \
		--with-ncurses \
		--with-msw=no \
		--with-mail-locking=flock \
		--with-site-lisp=yes \
		--with-site-modules=yes \
		--with-newgc \
		--enable-option-checking=no \
		--with-last-packages=/usr/lib/xemacs \
		|| die "configuration failed"
}

src_compile() {
	emake EMACSLOADPATH="${S}"/lisp
}

src_install() {
	emake prefix="${D}"/usr \
		mandir="${D}"/usr/share/man/man1 \
		infodir="${D}"/usr/share/info \
		libdir="${D}"/usr/$(get_libdir) \
		datadir="${D}"/usr/share \
		install || die

	# Rename some applications installed in bin so that it is clear
	# which application installed them and so that conflicting
	# packages (emacs) can't clobber the actual applications.
	# Addresses bug #62991.
	for i in b2m ctags etags gnuclient gnudoit gnuattach; do
		mv "${D}"/usr/bin/${i} "${D}"/usr/bin/${i}-xemacs || die "mv ${i} failed"
	done

	# rename man pages
	for i in ctags etags gnuserv gnuclient gnudoit gnuattach; do
		mv "${D}"/usr/share/man/man1/${i}{,-xemacs}.1 || die "mv ${i}.1 failed"
	done

	# install base packages directories
	dodir /usr/lib/xemacs/xemacs-packages/
	dodir /usr/lib/xemacs/site-packages/
	dodir /usr/lib/xemacs/site-modules/
	dodir /usr/lib/xemacs/site-lisp/

	if use mule;
	then
		dodir /usr/lib/xemacs/mule-packages
	fi

	# remove extraneous info files
	cd "${D}"/usr/share/info
	rm -f dir info.info texinfo* termcap* standards*

	cd "${S}"
	dodoc CHANGES-* ChangeLog INSTALL Installation PROBLEMS README*

	newicon "${S}"/etc/${PN}-icon.xpm ${PN}.xpm

	domenu "${FILESDIR}"/${PN}.desktop
}

pkg_postinst() {
	eselect emacs update ifunset
	eselect gnuclient update ifunset

	einfo "*************************************************"
	einfo "If you are upgrading from XEmacs 21.4 you should note the following"
	einfo "incompatibilities:"
	einfo "- Mule-UCS is no longer supported due to proper UTF-8 support in XEmacs 21.5"
	einfo "- The X resource class has changed from Emacs to XEmacs,"
	einfo "  settings in your .Xdefaults file should be updated accordingly."

	if use xft;
	then
	  einfo "You have enabled Xft font support. Xft requires font names to be provided"
	  einfo "in a different way, so you may need to adjust your .Xdefaults accordingly."
	fi
}

pkg_postrm() {
	eselect emacs update ifunset
	eselect gnuclient update ifunset
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Note: xemacs currently does not work with position independent code
# so the build forces the use of the -no-pie option

EAPI=8

inherit flag-o-matic xdg-utils desktop autotools

DESCRIPTION="highly customizable open source text editor and application development system"
HOMEPAGE="https://www.xemacs.org/"

SRC_URI="http://ftp.xemacs.org/pub/xemacs/xemacs-$(ver_cut 1-2)/${P}.tar.gz
	neXt? ( http://www.malfunction.de/afterstep/files/NeXT_XEmacs.tar.gz )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ppc64 ~riscv sparc ~x86"
IUSE="alsa debug gif gpm pop postgres ldap xface nas dnd X jpeg tiff png motif xft xim athena neXt Xaw3d gdbm berkdb +bignum"

X_DEPEND="x11-libs/libXt x11-libs/libXmu x11-libs/libXext x11-misc/xbitmaps"

RDEPEND="
	berkdb? ( >=sys-libs/db-4:= )
	gdbm? ( >=sys-libs/gdbm-1.8.3:=[berkdb(+)] )
	>=sys-libs/zlib-1.1.4
	>=dev-libs/openssl-0.9.6:0=
	>=media-libs/audiofile-0.2.3
	gpm? ( >=sys-libs/gpm-1.19.6 )
	postgres? ( dev-db/postgresql:= )
	ldap? ( net-nds/openldap:= )
	alsa? ( media-libs/alsa-lib )
	nas? ( media-libs/nas )
	X? ( $X_DEPEND !Xaw3d? ( !neXt? ( x11-libs/libXaw ) ) )
	dnd? ( x11-libs/dnd )
	motif? ( >=x11-libs/motif-2.3:0[xft=] )
	athena? ( x11-libs/libXaw )
	Xaw3d? ( x11-libs/libXaw3d[unicode(+)] )
	xft? ( media-libs/freetype:2 x11-libs/libXft x11-libs/libXrender >=media-libs/fontconfig-2.5.0 )
	neXt? ( x11-libs/neXtaw )
	xface? ( media-libs/compface )
	tiff? ( media-libs/tiff:= )
	png? ( >=media-libs/libpng-1.2:0 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	>=sys-libs/ncurses-5.2:=
	>=app-eselect/eselect-emacs-1.15
	bignum? ( dev-libs/openssl )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

BDEPEND="sys-apps/texinfo"

PDEPEND="app-xemacs/xemacs-base
	app-xemacs/mule-base"

src_unpack() {
	default_src_unpack
}

src_prepare() {
	use neXt && cp "${WORKDIR}"/NeXT.XEmacs/xemacs-icons/* "${S}"/etc/toolbar/
	find "${S}"/lisp -name '*.elc' -exec rm {} \; || die
	eapply "${FILESDIR}/${P}-configure.patch"
	eapply "${FILESDIR}/${P}-mule-tests.patch"
	eapply "${FILESDIR}/${P}-configure-libc-version.patch"
	eapply "${FILESDIR}/${P}-which.patch"
	eapply "${FILESDIR}/${P}-misalignment.patch"
	eapply "${FILESDIR}/${P}-va_args.patch"
	eapply "${FILESDIR}/${P}-linker-flags.patch"

	eapply_user

	eautoconf

	# Some binaries and man pages are installed under suffixed names
	# to avoid collions with their GNU Emacs counterparts (see below).
	# Fix internal filename references.
	sed -i -e 's/exec gnuclient/&-xemacs/' lib-src/gnudoit || die
	sed -i -e '/^\.so/s/etags/&-xemacs/' etc/ctags.1 || die
	sed -i -e '/^\.so/s/gnuserv/&-xemacs/' etc/gnu{client,doit,attach}.1 || die
}

src_configure() {
	local myconf=""

	# bug #639642
	test-flags -no-pie >/dev/null && append-flags -no-pie
	filter-flags -pie

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

		use dnd && myconf="${myconf} --with-dragndrop"

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

	if use xim ; then
		if use motif ; then
			myconf="${myconf} --with-xim=motif"
		else
		myconf="${myconf} --with-xim=xlib"
		fi
	else
	  myconf="${myconf} --with-xim=no"
	fi

	myconf="${myconf} --without-wnn"

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

	if use debug ; then
		myconf="${myconf} --with-debug"
		# bug #924339
		append-flags -fno-strict-aliasing
	else
		myconf="${myconf} --with-optimization --with-cflags-debugging="
	fi

	use bignum && myconf="${myconf} --with-bignum=openssl" ||
		myconf="${myconf} --with-bignum=no"

	econf ${myconf} \
		$(use_with gif ) \
		$(use_with gpm ) \
		$(use_with postgres postgresql ) \
		$(use_with ldap ) \
		$(use_with pop ) \
		--prefix=/usr \
		--with-mule \
		--with-unicode-internal \
		--without-canna \
		--with-ncurses \
		--with-msw=no \
		--with-mail-locking=flock \
		--with-site-lisp=yes \
		--with-site-modules=yes \
		--enable-option-checking=no \
		--with-last-packages=/usr/lib/xemacs
}

src_compile() {
	emake EMACSLOADPATH="${S}"/lisp
}

src_install() {
	emake prefix="${ED}"/usr \
		mandir="${ED}"/usr/share/man/man1 \
		infodir="${ED}"/usr/share/info \
		libdir="${ED}"/usr/$(get_libdir) \
		datadir="${ED}"/usr/share \
		install

	# Rename some applications installed in bin so that it is clear
	# which application installed them and so that conflicting
	# packages (emacs) can't clobber the actual applications.
	# Addresses bug #62991.
	for i in b2m ctags etags gnuclient gnudoit gnuattach; do
		mv "${ED}"/usr/bin/${i} "${ED}"/usr/bin/${i}-xemacs || die "mv ${i} failed"
	done

	# rename man pages
	for i in ctags etags gnuserv gnuclient gnudoit gnuattach; do
		mv "${ED}"/usr/share/man/man1/${i}{,-xemacs}.1 || die "mv ${i}.1 failed"
	done

	# install base packages directories
	dodir /usr/lib/xemacs/xemacs-packages/
	dodir /usr/lib/xemacs/site-packages/
	dodir /usr/lib/xemacs/site-modules/
	dodir /usr/lib/xemacs/site-lisp/
	dodir /usr/lib/xemacs/mule-packages

	# remove extraneous info files
	cd "${ED}"/usr/share/info
	rm -f dir info.info texinfo* termcap* standards*

	cd "${S}"
	dodoc CHANGES-* ChangeLog INSTALL Installation PROBLEMS README*

	newicon "${S}"/etc/${PN}-icon.xpm ${PN}.xpm

	domenu "${FILESDIR}"/${PN}.desktop
}

pkg_postinst() {
	eselect emacs update ifunset
	eselect gnuclient update ifunset
	xdg_desktop_database_update

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
	xdg_desktop_database_update
}

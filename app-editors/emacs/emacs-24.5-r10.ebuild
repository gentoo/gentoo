# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common flag-o-matic readme.gentoo-r1

DESCRIPTION="The extensible, customizable, self-documenting real-time display editor"
HOMEPAGE="https://www.gnu.org/software/emacs/"
SRC_URI="mirror://gnu/emacs/${P}.tar.xz
	https://dev.gentoo.org/~ulm/emacs/${P}-patches-5.tar.xz"

LICENSE="GPL-3+ FDL-1.3+ BSD HPND MIT W3C unicode PSF-2"
SLOT="24"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="acl alsa aqua athena dbus games gconf gfile gif gpm gsettings gtk gui gzip-el imagemagick +inotify jpeg kerberos libxml2 livecd m17n-lib motif png selinux sound source ssl svg tiff toolkit-scroll-bars wide-int Xaw3d xft +xpm zlib"

RDEPEND="acct-group/mail
	app-emacs/emacs-common-gentoo[games?,gui(-)?]
	net-libs/liblockfile
	sys-libs/ncurses:0=
	acl? ( virtual/acl )
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	games? ( acct-group/gamestat )
	gpm? ( sys-libs/gpm )
	!inotify? ( gfile? ( >=dev-libs/glib-2.28.6 ) )
	kerberos? ( virtual/krb5 )
	libxml2? ( >=dev-libs/libxml2-2.2.0 )
	selinux? ( sys-libs/libselinux )
	ssl? ( net-libs/gnutls:0= )
	zlib? ( sys-libs/zlib )
	gui? ( !aqua? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-misc/xbitmaps
		gconf? ( >=gnome-base/gconf-2.26.2 )
		gsettings? ( >=dev-libs/glib-2.28.6 )
		gif? ( media-libs/giflib:0= )
		jpeg? ( virtual/jpeg:0= )
		png? ( >=media-libs/libpng-1.4:0= )
		svg? ( >=gnome-base/librsvg-2.0 )
		tiff? ( media-libs/tiff:0 )
		xpm? ( x11-libs/libXpm )
		imagemagick? ( >=media-gfx/imagemagick-6.6.2:0= )
		xft? (
			media-libs/fontconfig
			media-libs/freetype
			x11-libs/libXft
			x11-libs/libXrender
			m17n-lib? (
				>=dev-libs/libotf-0.9.4
				>=dev-libs/m17n-lib-1.5.1
			)
		)
		gtk? ( x11-libs/gtk+:3 )
		!gtk? (
			motif? (
				>=x11-libs/motif-2.3:0
				x11-libs/libXpm
				x11-libs/libXmu
				x11-libs/libXt
			)
			!motif? (
				Xaw3d? (
					x11-libs/libXaw3d
					x11-libs/libXmu
					x11-libs/libXt
				)
				!Xaw3d? ( athena? (
					x11-libs/libXaw
					x11-libs/libXmu
					x11-libs/libXt
				) )
			)
		)
	) )"

DEPEND="${RDEPEND}
	gui? ( !aqua? ( x11-base/xorg-proto ) )"

BDEPEND="app-eselect/eselect-emacs
	virtual/pkgconfig
	gzip-el? ( app-arch/gzip )"

RDEPEND="${RDEPEND}
	app-eselect/eselect-emacs"

EMACS_SUFFIX="emacs-${SLOT}"
SITEFILE="20${EMACS_SUFFIX}-gentoo.el"
# FULL_VERSION keeps the full version number, which is needed in
# order to determine some path information correctly for copy/move
# operations later on
FULL_VERSION="${PV%%_*}"
S="${WORKDIR}/emacs-${FULL_VERSION}"

src_prepare() {
	eapply ../patch
	eapply_user

	# Fix filename reference in redirected man page
	sed -i -e "/^\\.so/s/etags/&-${EMACS_SUFFIX}/" doc/man/ctags.1 \
		|| die "unable to sed ctags.1"

	AT_M4DIR=m4 eautoreconf
	touch src/stamp-h.in || die
}

src_configure() {
	strip-flags
	filter-flags -pie					#526948
	append-ldflags $(test-flags -no-pie)	#639570

	if use ia64; then
		replace-flags "-O[2-9]" -O1		#325373
	else
		replace-flags "-O[3-9]" -O2
	fi

	# Don't trigger a floating point exception for NaNs on alpha
	use alpha && append-flags -mieee

	local myconf

	if use alsa; then
		use sound || ewarn \
			"USE flag \"alsa\" overrides \"-sound\"; enabling sound support."
		myconf+=" --with-sound=alsa"
	else
		myconf+=" --with-sound=$(usex sound oss)"
	fi

	if ! use gui; then
		einfo "Configuring to build without window system support"
		myconf+=" --without-x --without-ns"
	elif use aqua; then
		einfo "Configuring to build with Nextstep (Macintosh Cocoa) support"
		myconf+=" --with-ns --disable-ns-self-contained"
		myconf+=" --without-x"
	else
		myconf+=" --with-x --without-ns"
		myconf+=" $(use_with gconf)"
		myconf+=" $(use_with gsettings)"
		myconf+=" $(use_with toolkit-scroll-bars)"
		myconf+=" $(use_with gif)"
		myconf+=" $(use_with jpeg)"
		myconf+=" $(use_with png)"
		myconf+=" $(use_with svg rsvg)"
		myconf+=" $(use_with tiff)"
		myconf+=" $(use_with xpm)"
		myconf+=" $(use_with imagemagick)"

		if use xft; then
			myconf+=" --with-xft"
			myconf+=" $(use_with m17n-lib libotf)"
			myconf+=" $(use_with m17n-lib m17n-flt)"
		else
			myconf+=" --without-xft"
			myconf+=" --without-libotf --without-m17n-flt"
			use m17n-lib && ewarn \
				"USE flag \"m17n-lib\" has no effect if \"xft\" is not set."
		fi

		local f line
		if use gtk; then
			einfo "Configuring to build with GIMP Toolkit (GTK+)"
			while read line; do ewarn "${line}"; done <<-EOF
				Your version of GTK+ will have problems with closing open
				displays. This is no problem if you just use one display, but
				if you use more than one and close one of them Emacs may crash.
				See <https://gitlab.gnome.org/GNOME/gtk/-/issues/221> and
				<https://gitlab.gnome.org/GNOME/gtk/-/issues/2315>.
				If you intend to use more than one display, then it is strongly
				recommended that you compile Emacs with the Athena/Lucid or the
				Motif toolkit instead.
			EOF
			myconf+=" --with-x-toolkit=gtk3"
			for f in motif Xaw3d athena; do
				use ${f} && ewarn \
					"USE flag \"${f}\" has no effect if \"gtk\" is set."
			done
		elif use motif; then
			einfo "Configuring to build with Motif toolkit"
			myconf+=" --with-x-toolkit=motif"
			for f in Xaw3d athena; do
				use ${f} && ewarn \
					"USE flag \"${f}\" has no effect if \"motif\" is set."
			done
		elif use athena || use Xaw3d; then
			einfo "Configuring to build with Athena/Lucid toolkit"
			myconf+=" --with-x-toolkit=lucid $(use_with Xaw3d xaw3d)"
		else
			einfo "Configuring to build with no toolkit"
			myconf+=" --with-x-toolkit=no"
		fi
	fi

	econf \
		--program-suffix="-${EMACS_SUFFIX}" \
		--infodir="${EPREFIX}"/usr/share/info/${EMACS_SUFFIX} \
		--localstatedir="${EPREFIX}"/var \
		--enable-locallisppath="${EPREFIX}/etc/emacs:${EPREFIX}${SITELISP}" \
		--with-gameuser=":gamestat" \
		--without-compress-install \
		--without-hesiod \
		--with-file-notification=$(usev inotify || usev gfile || echo no) \
		$(use_enable acl) \
		$(use_with dbus) \
		$(use_with gpm) \
		$(use_with kerberos) $(use_with kerberos kerberos5) \
		$(use_with libxml2 xml2) \
		$(use_with selinux) \
		$(use_with ssl gnutls) \
		$(use_with wide-int) \
		$(use_with zlib) \
		${myconf}
}

src_compile() {
	# Disable sandbox when dumping. For the unbelievers, see bug #131505
	emake RUN_TEMACS="SANDBOX_ON=0 LD_PRELOAD= env ./temacs"
}

src_install() {
	emake DESTDIR="${D}" NO_BIN_LINK=t BLESSMAIL_TARGET= install

	mv "${ED}"/usr/bin/{emacs-${FULL_VERSION}-,}${EMACS_SUFFIX} \
		|| die "moving emacs executable failed"
	mv "${ED}"/usr/share/man/man1/{emacs-,}${EMACS_SUFFIX}.1 \
		|| die "moving emacs man page failed"

	# move info dir to avoid collisions with the dir file generated by portage
	mv "${ED}"/usr/share/info/${EMACS_SUFFIX}/dir{,.orig} \
		|| die "moving info dir failed"
	touch "${ED}"/usr/share/info/${EMACS_SUFFIX}/.keepinfodir
	docompress -x /usr/share/info/${EMACS_SUFFIX}/dir.orig

	# movemail must be setgid mail
	fowners root:mail /usr/libexec/emacs/${FULL_VERSION}/${CHOST}/movemail
	fperms 2751 /usr/libexec/emacs/${FULL_VERSION}/${CHOST}/movemail

	# avoid collision between slots, see bug #169033 e.g.
	rm "${ED}"/usr/share/emacs/site-lisp/subdirs.el
	rm -rf "${ED}"/usr/share/{applications,icons}
	rm -rf "${ED}"/var

	# remove unused <version>/site-lisp dir
	rm -rf "${ED}"/usr/share/emacs/${FULL_VERSION}/site-lisp

	# remove COPYING file (except for etc/COPYING used by describe-copying)
	rm "${ED}"/usr/share/emacs/${FULL_VERSION}/lisp/COPYING

	if use gzip-el; then
		# compress .el files when a corresponding .elc exists
		find "${ED}"/usr/share/emacs/${FULL_VERSION}/lisp -type f \
			-name "*.elc" -print | sed 's/\.elc$/.el/' | xargs gzip -9n
		assert "gzip .el failed"
	fi

	local cdir
	if use source; then
		cdir="/usr/share/emacs/${FULL_VERSION}/src"
		insinto "${cdir}"
		# This is not meant to install all the source -- just the
		# C source you might find via find-function
		doins src/*.{c,h,m}
	elif has installsources ${FEATURES}; then
		cdir="/usr/src/debug/${CATEGORY}/${PF}/${S#"${WORKDIR}/"}/src"
	fi

	sed -e "${cdir:+#}/^Y/d" -e "s/^[XY]//" >"${T}/${SITEFILE}" <<-EOF || die
	X
	;;; ${EMACS_SUFFIX} site-lisp configuration
	X
	(when (string-match "\\\\\`${FULL_VERSION//./\\\\.}\\\\>" emacs-version)
	Y  (setq find-function-C-source-directory
	Y	"${EPREFIX}${cdir}")
	X  (let ((path (getenv "INFOPATH"))
	X	(dir "${EPREFIX}/usr/share/info/${EMACS_SUFFIX}")
	X	(re "\\\\\`${EPREFIX}/usr/share\\\\>"))
	X    (and path
	X	 ;; move Emacs Info dir before anything else in /usr/share
	X	 (let* ((p (cons nil (split-string path ":" t))) (q p))
	X	   (while (and (cdr q) (not (string-match re (cadr q))))
	X	     (setq q (cdr q)))
	X	   (setcdr q (cons dir (delete dir (cdr q))))
	X	   (setq Info-directory-list (prune-directory-list (cdr p)))))))
	EOF
	elisp-site-file-install "${T}/${SITEFILE}" || die

	dodoc README BUGS

	if use gui && use aqua; then
		dodir /Applications/Gentoo
		rm -rf "${ED}"/Applications/Gentoo/${EMACS_SUFFIX^}.app
		mv nextstep/Emacs.app \
			"${ED}"/Applications/Gentoo/${EMACS_SUFFIX^}.app || die
	fi

	local DOC_CONTENTS="You can set the version to be started by
		/usr/bin/emacs through the Emacs eselect module, which also
		redirects man and info pages. Therefore, several Emacs versions can
		be installed at the same time. \"man emacs.eselect\" for details.
		\\n\\nIf you upgrade from Emacs version 24.2 or earlier, then it is
		strongly recommended that you use app-admin/emacs-updater to rebuild
		all byte-compiled elisp files of the installed Emacs packages."
	if use gui; then
		DOC_CONTENTS+="\\n\\nYou need to install some fonts for Emacs.
			Installing media-fonts/font-adobe-{75,100}dpi on the X server's
			machine would satisfy basic Emacs requirements under X11.
			See also https://wiki.gentoo.org/wiki/Xft_support_for_GNU_Emacs
			for how to enable anti-aliased fonts."
		use aqua && DOC_CONTENTS+="\\n\\n${EMACS_SUFFIX^}.app is in
			\"${EPREFIX}/Applications/Gentoo\". You may want to copy or
			symlink it into /Applications by yourself."
	fi
	readme.gentoo_create_doc
}

pkg_preinst() {
	# move Info dir file to correct name
	if [[ -d ${ED}/usr/share/info ]]; then
		mv "${ED}"/usr/share/info/${EMACS_SUFFIX}/dir{.orig,} || die
	fi
}

pkg_postinst() {
	elisp-site-regen
	readme.gentoo_print_elog

	if use livecd; then
		# force an update of the emacs symlink for the livecd/dvd,
		# because some microemacs packages set it with USE=livecd
		eselect emacs update
	elif [[ $(readlink "${EROOT}"/usr/bin/emacs) = ${EMACS_SUFFIX} ]]; then
		# refresh symlinks in case any installed files have changed
		eselect emacs set ${EMACS_SUFFIX}
	else
		eselect emacs update ifunset
	fi
}

pkg_postrm() {
	elisp-site-regen
	eselect emacs update ifunset
}

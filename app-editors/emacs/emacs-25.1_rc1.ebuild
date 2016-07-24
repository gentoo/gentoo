# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp-common flag-o-matic multilib readme.gentoo-r1

DESCRIPTION="The extensible, customizable, self-documenting real-time display editor"
HOMEPAGE="https://www.gnu.org/software/emacs/"
SRC_URI="mirror://gnu-alpha/emacs/pretest/emacs-${PV/_/-}.tar.xz"

LICENSE="GPL-3+ FDL-1.3+ BSD HPND MIT W3C unicode PSF-2"
SLOT="25"
KEYWORDS=""
IUSE="acl alsa aqua athena cairo dbus games gconf gfile gif gpm gsettings gtk +gtk3 gzip-el hesiod imagemagick +inotify jpeg kerberos libxml2 livecd m17n-lib motif pax_kernel png selinux sound source ssl svg tiff toolkit-scroll-bars wide-int X Xaw3d xft +xpm xwidgets zlib"
REQUIRED_USE="?? ( aqua X )"

RDEPEND="sys-libs/ncurses:0
	>=app-eselect/eselect-emacs-1.16
	>=app-emacs/emacs-common-gentoo-1.5[games?,X?]
	net-libs/liblockfile
	acl? ( virtual/acl )
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	gpm? ( sys-libs/gpm )
	hesiod? ( net-dns/hesiod )
	!inotify? ( gfile? ( >=dev-libs/glib-2.28.6 ) )
	kerberos? ( virtual/krb5 )
	libxml2? ( >=dev-libs/libxml2-2.2.0 )
	selinux? ( sys-libs/libselinux )
	ssl? ( net-libs/gnutls )
	zlib? ( sys-libs/zlib )
	X? (
		x11-libs/libXmu
		x11-libs/libXt
		x11-misc/xbitmaps
		gconf? ( >=gnome-base/gconf-2.26.2 )
		gsettings? ( >=dev-libs/glib-2.28.6 )
		gif? ( media-libs/giflib:0= )
		jpeg? ( virtual/jpeg:0= )
		png? ( >=media-libs/libpng-1.4:0= )
		svg? ( >=gnome-base/librsvg-2.0 )
		tiff? ( media-libs/tiff:0 )
		xpm? ( x11-libs/libXpm )
		imagemagick? ( >=media-gfx/imagemagick-6.6.2 )
		xft? (
			media-libs/fontconfig
			media-libs/freetype
			x11-libs/libXft
			cairo? ( >=x11-libs/cairo-1.12.18 )
			m17n-lib? (
				>=dev-libs/libotf-0.9.4
				>=dev-libs/m17n-lib-1.5.1
			)
		)
		gtk? (
			xwidgets? (
				x11-libs/gtk+:3
				net-libs/webkit-gtk:3=
			)
			!xwidgets? (
				gtk3? ( x11-libs/gtk+:3 )
				!gtk3? ( x11-libs/gtk+:2 )
			)
		)
		!gtk? (
			motif? ( >=x11-libs/motif-2.3:0 )
			!motif? (
				Xaw3d? ( x11-libs/libXaw3d )
				!Xaw3d? ( athena? ( x11-libs/libXaw ) )
			)
		)
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	gzip-el? ( app-arch/gzip )
	pax_kernel? (
		sys-apps/attr
		sys-apps/paxctl
	)"

RDEPEND="${RDEPEND}
	!<app-editors/emacs-vcs-${PV}"

EMACS_SUFFIX="${PN/emacs/emacs-${SLOT}}"
SITEFILE="20${PN}-${SLOT}-gentoo.el"
# FULL_VERSION keeps the full version number, which is needed in
# order to determine some path information correctly for copy/move
# operations later on
FULL_VERSION="${PV%%_*}"
S="${WORKDIR}/emacs-${FULL_VERSION}"

src_prepare() {
	eapply_user

	# Fix filename reference in redirected man page
	sed -i -e "/^\\.so/s/etags/&-${EMACS_SUFFIX}/" doc/man/ctags.1 \
		|| die "unable to sed ctags.1"

	#AT_M4DIR=m4 eautoreconf
}

src_configure() {
	strip-flags
	filter-flags -pie					#526948

	if use sh; then
		replace-flags "-O[1-9]" -O0		#262359
	elif use ia64; then
		replace-flags "-O[2-9]" -O1		#325373
	else
		replace-flags "-O[3-9]" -O2
	fi

	local myconf

	if use alsa; then
		use sound || ewarn \
			"USE flag \"alsa\" overrides \"-sound\"; enabling sound support."
		myconf+=" --with-sound=alsa"
	else
		myconf+=" --with-sound=$(usex sound oss)"
	fi

	if use X; then
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
			myconf+=" $(use_with cairo)"
			myconf+=" $(use_with m17n-lib libotf)"
			myconf+=" $(use_with m17n-lib m17n-flt)"
		else
			myconf+=" --without-xft"
			myconf+=" --without-cairo"
			myconf+=" --without-libotf --without-m17n-flt"
			use cairo && ewarn \
				"USE flag \"cairo\" has no effect if \"xft\" is not set."
			use m17n-lib && ewarn \
				"USE flag \"m17n-lib\" has no effect if \"xft\" is not set."
		fi

		local f
		if use gtk; then
			einfo "Configuring to build with GIMP Toolkit (GTK+)"
			while read line; do ewarn "${line}"; done <<-EOF
				Your version of GTK+ will have problems with closing open
				displays. This is no problem if you just use one display, but
				if you use more than one and close one of them Emacs may crash.
				See <https://bugzilla.gnome.org/show_bug.cgi?id=85715>.
				If you intend to use more than one display, then it is strongly
				recommended that you compile Emacs with the Athena/Lucid or the
				Motif toolkit instead.
			EOF
			if use xwidgets; then
				myconf+=" --with-x-toolkit=gtk3 --with-xwidgets"
			else
				myconf+=" --with-x-toolkit=$(usex gtk3 gtk3 gtk2)"
				myconf+=" --without-xwidgets"
			fi
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
		! use gtk && use xwidgets && ewarn \
			"USE flag \"xwidgets\" has no effect if \"gtk\" is not set."
	elif use aqua; then
		einfo "Configuring to build with Nextstep (Cocoa) support"
		myconf+=" --with-ns --disable-ns-self-contained"
		myconf+=" --without-x"
	else
		myconf+=" --without-x --without-ns"
	fi

	# Save version information in the Emacs binary. It will be available
	# in variable "system-configuration-options".
	myconf+=" GENTOO_PACKAGE=${CATEGORY}/${PF}"

	econf \
		--program-suffix="-${EMACS_SUFFIX}" \
		--infodir="${EPREFIX}"/usr/share/info/${EMACS_SUFFIX} \
		--localstatedir="${EPREFIX}"/var \
		--enable-locallisppath="${EPREFIX}/etc/emacs:${EPREFIX}${SITELISP}" \
		--with-gameuser=":gamestat" \
		--without-compress-install \
		--with-file-notification=$(usev inotify || usev gfile || echo no) \
		$(use_enable acl) \
		$(use_with dbus) \
		$(use_with gpm) \
		$(use_with hesiod) \
		$(use_with kerberos) $(use_with kerberos kerberos5) \
		$(use_with libxml2 xml2) \
		$(use_with selinux) \
		$(use_with ssl gnutls) \
		$(use_with wide-int) \
		$(use_with zlib) \
		${myconf}
}

src_compile() {
	export SANDBOX_ON=0			# for the unbelievers, see Bug #131505
	emake
}

src_install () {
	emake DESTDIR="${D}" NO_BIN_LINK=t install

	mv "${ED}"/usr/bin/{emacs-${FULL_VERSION}-,}${EMACS_SUFFIX} \
		|| die "moving emacs executable failed"
	mv "${ED}"/usr/share/man/man1/{emacs-,}${EMACS_SUFFIX}.1 \
		|| die "moving emacs man page failed"

	# move info dir to avoid collisions with the dir file generated by portage
	mv "${ED}"/usr/share/info/${EMACS_SUFFIX}/dir{,.orig} \
		|| die "moving info dir failed"
	touch "${ED}"/usr/share/info/${EMACS_SUFFIX}/.keepinfodir
	docompress -x /usr/share/info/${EMACS_SUFFIX}/dir.orig

	# avoid collision between slots, see bug #169033 e.g.
	rm "${ED}"/usr/share/emacs/site-lisp/subdirs.el
	rm -rf "${ED}"/usr/share/{appdata,applications,icons}
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

	sed -e "${cdir:+#}/^Y/d" -e "s/^[XY]//" >"${T}/${SITEFILE}" <<-EOF
	X
	;;; ${PN}-${SLOT} site-lisp configuration
	X
	(when (string-match "\\\\\`${FULL_VERSION//./\\\\.}\\\\>" emacs-version)
	Y  (setq find-function-C-source-directory
	Y	"${EPREFIX}${cdir}")
	X  (let ((path (getenv "INFOPATH"))
	X	(dir "${EPREFIX}/usr/share/info/${EMACS_SUFFIX}")
	X	(re "\\\\\`${EPREFIX}/usr/share/info\\\\>"))
	X    (and path
	X	 ;; move Emacs Info dir before anything else in /usr/share/info
	X	 (let* ((p (cons nil (split-string path ":" t))) (q p))
	X	   (while (and (cdr q) (not (string-match re (cadr q))))
	X	     (setq q (cdr q)))
	X	   (setcdr q (cons dir (delete dir (cdr q))))
	X	   (setq Info-directory-list (prune-directory-list (cdr p)))))))
	EOF
	elisp-site-file-install "${T}/${SITEFILE}" || die

	dodoc README BUGS CONTRIBUTE

	if use aqua; then
		dodir /Applications/Gentoo
		rm -rf "${ED}"/Applications/Gentoo/Emacs${EMACS_SUFFIX#emacs}.app
		mv nextstep/Emacs.app \
			"${ED}"/Applications/Gentoo/Emacs${EMACS_SUFFIX#emacs}.app || die
	fi

	DOC_CONTENTS="You can set the version to be started by /usr/bin/emacs
		through the Emacs eselect module, which also redirects man and info
		pages. Therefore, several Emacs versions can be installed at the
		same time. \"man emacs.eselect\" for details.
		\\n\\nIf you upgrade from Emacs version 24.2 or earlier, then it is
		strongly recommended that you use app-admin/emacs-updater to rebuild
		all byte-compiled elisp files of the installed Emacs packages."
	use X && DOC_CONTENTS+="\\n\\nYou need to install some fonts for Emacs.
		Installing media-fonts/font-adobe-{75,100}dpi on the X server's
		machine would satisfy basic Emacs requirements under X11.
		See also https://wiki.gentoo.org/wiki/Xft_support_for_GNU_Emacs
		for how to enable anti-aliased fonts."
	use aqua && DOC_CONTENTS+="\\n\\nEmacs${EMACS_SUFFIX#emacs}.app is in
		\"${EPREFIX}/Applications/Gentoo\". You may want to copy or symlink
		it into /Applications by yourself."
	readme.gentoo_create_doc
}

pkg_preinst() {
	# move Info dir file to correct name
	local infodir=/usr/share/info/${EMACS_SUFFIX} f
	if [[ -f ${ED}${infodir}/dir.orig ]]; then
		mv "${ED}"${infodir}/dir{.orig,} || die "moving info dir failed"
	elif [[ -d "${ED}"${infodir} ]]; then
		# this should not happen in EAPI 4
		ewarn "Regenerating Info directory index in ${infodir} ..."
		rm -f "${ED}"${infodir}/dir{,.*}
		for f in "${ED}"${infodir}/*; do
			if [[ ${f##*/} != *-[0-9]* && -e ${f} ]]; then
				install-info --info-dir="${ED}"${infodir} "${f}" \
					|| die "install-info failed"
			fi
		done
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

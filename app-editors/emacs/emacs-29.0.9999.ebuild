# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common readme.gentoo-r1 toolchain-funcs

if [[ ${PV##*.} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/emacs.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/emacs"
	S="${EGIT_CHECKOUT_DIR}"
	SLOT="${PV%%.*}-vcs"
else
	# FULL_VERSION keeps the full version number, which is needed in
	# order to determine some path information correctly for copy/move
	# operations later on
	FULL_VERSION="${PV%%_*}"
	SRC_URI="mirror://gnu/emacs/${P}.tar.xz"
	S="${WORKDIR}/emacs-${FULL_VERSION}"
	# PV can be in any of the following formats:
	# 27.1                 released version (slot 27)
	# 27.1_rc1             upstream release candidate (27)
	# 27.0.9999            live ebuild (slot 27-vcs)
	# 27.0.90              upstream prerelease snapshot (27-vcs)
	# 27.0.50_pre20191223  snapshot by Gentoo developer (27-vcs)
	if [[ ${PV} == *_pre* ]]; then
		SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"
		S="${WORKDIR}/emacs"
	elif [[ ${PV//[0-9]} != "." ]]; then
		SRC_URI="https://alpha.gnu.org/gnu/emacs/pretest/${PN}-${PV/_/-}.tar.xz"
	fi
	SLOT="${PV%%.*}"
	[[ ${PV} == *.*.* ]] && SLOT+="-vcs"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

DESCRIPTION="The extensible, customizable, self-documenting real-time display editor"
HOMEPAGE="https://www.gnu.org/software/emacs/"

LICENSE="GPL-3+ FDL-1.3+ BSD HPND MIT W3C unicode PSF-2"
IUSE="acl alsa aqua athena cairo dbus dynamic-loading games gfile gif +gmp gpm gsettings gtk gui gzip-el harfbuzz imagemagick +inotify jit jpeg json kerberos lcms libxml2 livecd m17n-lib mailutils motif png selinux sound source sqlite ssl svg systemd +threads tiff toolkit-scroll-bars tree-sitter webp wide-int +X Xaw3d xft +xpm xwidgets zlib"

X_DEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-misc/xbitmaps
	xpm? ( x11-libs/libXpm )
	xft? (
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/libXft
		x11-libs/libXrender
		cairo? ( >=x11-libs/cairo-1.12.18[X] )
		harfbuzz? ( media-libs/harfbuzz:0= )
		m17n-lib? (
			>=dev-libs/libotf-0.9.4
			>=dev-libs/m17n-lib-1.5.1
		)
	)
	gtk? (
		x11-libs/gtk+:3
		xwidgets? (
			net-libs/webkit-gtk:4=
			x11-libs/libXcomposite
		)
	)
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
	)"

RDEPEND="app-emacs/emacs-common[games?,gui(-)?]
	sys-libs/ncurses:0=
	acl? ( virtual/acl )
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	games? ( acct-group/gamestat )
	gmp? ( dev-libs/gmp:0= )
	gpm? ( sys-libs/gpm )
	!inotify? ( gfile? ( >=dev-libs/glib-2.28.6 ) )
	jit? (
		sys-devel/gcc:=[jit(-)]
		sys-libs/zlib
	)
	json? ( dev-libs/jansson:= )
	kerberos? ( virtual/krb5 )
	lcms? ( media-libs/lcms:2 )
	libxml2? ( >=dev-libs/libxml2-2.2.0 )
	mailutils? ( net-mail/mailutils[clients] )
	!mailutils? ( acct-group/mail net-libs/liblockfile )
	selinux? ( sys-libs/libselinux )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( net-libs/gnutls:0= )
	systemd? ( sys-apps/systemd )
	tree-sitter? ( dev-libs/tree-sitter )
	zlib? ( sys-libs/zlib )
	gui? (
		gif? ( media-libs/giflib:0= )
		jpeg? ( media-libs/libjpeg-turbo:0= )
		png? ( >=media-libs/libpng-1.4:0= )
		svg? ( >=gnome-base/librsvg-2.0 )
		tiff? ( media-libs/tiff:0 )
		webp? ( media-libs/libwebp:0= )
		imagemagick? ( >=media-gfx/imagemagick-6.6.2:0= )
		!aqua? (
			gsettings? ( >=dev-libs/glib-2.28.6 )
			gtk? ( !X? (
				media-libs/fontconfig
				media-libs/freetype
				>=x11-libs/cairo-1.12.18
				x11-libs/gtk+:3
				harfbuzz? ( media-libs/harfbuzz:0= )
				m17n-lib? (
					>=dev-libs/libotf-0.9.4
					>=dev-libs/m17n-lib-1.5.1
				)
				xwidgets? ( net-libs/webkit-gtk:4= )
			) )
			!gtk? ( ${X_DEPEND} )
			X? ( ${X_DEPEND} )
		)
	)"

DEPEND="${RDEPEND}
	gui? ( !aqua? (
		!gtk? ( x11-base/xorg-proto )
		X? ( x11-base/xorg-proto )
	) )"

BDEPEND="sys-apps/texinfo
	virtual/pkgconfig
	gzip-el? ( app-arch/gzip )"

IDEPEND="app-eselect/eselect-emacs"

RDEPEND+=" ${IDEPEND}"

EMACS_SUFFIX="emacs-${SLOT}"
SITEFILE="20${EMACS_SUFFIX}-gentoo.el"

src_prepare() {
	if [[ ${PV##*.} = 9999 ]]; then
		FULL_VERSION=$(sed -n 's/^AC_INIT([^,]*,[^0-9.]*\([0-9.]*\).*/\1/p' \
			configure.ac)
		[[ ${FULL_VERSION} ]] || die "Cannot determine current Emacs version"
		einfo "Emacs branch: ${EGIT_BRANCH}"
		einfo "Commit: ${EGIT_VERSION}"
		einfo "Emacs version number: ${FULL_VERSION}"
		[[ ${FULL_VERSION} =~ ^${PV%.*}(\..*)?$ ]] \
			|| die "Upstream version number changed to ${FULL_VERSION}"
	fi

	if use jit; then
		find lisp -type f -name "*.elc" -delete || die

		# These files ignore LDFLAGS. We assign the variable here, because
		# for live ebuilds FULL_VERSION doesn't exist in global scope
		QA_FLAGS_IGNORED="usr/$(get_libdir)/emacs/${FULL_VERSION}/native-lisp/.*"

		# gccjit doesn't play well with ccache or distcc #801580
		# For now, work around the problem with an explicit LIBRARY_PATH
		has ccache ${FEATURES} || has distcc ${FEATURES} && tc-is-gcc \
			&& export LIBRARY_PATH=$("$(tc-getCC)" -print-search-dirs \
				| sed -n '/^libraries:/{s:^[^/]*::;p}')
	fi

	default

	# Fix filename reference in redirected man page
	sed -i -e "/^\\.so/s/etags/&-${EMACS_SUFFIX}/" doc/man/ctags.1 || die

	# libseccomp is detected by configure but doesn't appear to have any
	# effect on the installed image. Suppress it by supplying pkg-config
	# with a wrong library name.
	sed -i -e "/CHECK_MODULES/s/libseccomp/DiSaBlE&/" configure.ac || die

	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	local myconf

	# Prevents e.g. tests interfering with running Emacs.
	unset EMACS_SOCKET_NAME

	if use alsa; then
		use sound || ewarn \
			"USE flag \"alsa\" overrides \"-sound\"; enabling sound support."
		myconf+=" --with-sound=alsa"
	else
		myconf+=" --with-sound=$(usex sound oss)"
	fi

	# Emacs supports these window systems:
	# X11, pure GTK (without X11), or Nextstep (Aqua/Cocoa).
	# General GUI support is enabled by the "gui" USE flag, then
	# the window system is selected as follows:
	#   "aqua" -> Nextstep
	#   "gtk -X" -> pure GTK
	#   otherwise -> X11
	# For X11 there is the further choice of toolkits GTK, Motif,
	# Athena (Lucid), or no toolkit. They are enabled (in order of
	# preference) with the "gtk", "motif", "Xaw3d", and "athena" flags.

	if use jit; then
		use zlib || ewarn \
			"USE flag \"jit\" overrides \"-zlib\"; enabling zlib support."
		myconf+=" --with-zlib"
	else
		myconf+=" $(use_with zlib)"
	fi

	if ! use gui; then
		einfo "Configuring to build without window system support"
		myconf+=" --without-x --without-pgtk --without-ns"
	elif use aqua; then
		einfo "Configuring to build with Nextstep (Macintosh Cocoa) support"
		myconf+=" --with-ns --disable-ns-self-contained"
		myconf+=" --without-x --without-pgtk"
	elif use gtk && ! use X; then
		einfo "Configuring to build with pure GTK (without X11) support"
		myconf+=" --with-pgtk --without-x --without-ns"
		myconf+=" --with-toolkit-scroll-bars" #836392
		myconf+=" --without-gconf"
		myconf+=" $(use_with gsettings)"
		myconf+=" $(use_with harfbuzz)"
		myconf+=" $(use_with m17n-lib libotf)"
		myconf+=" $(use_with m17n-lib m17n-flt)"
		myconf+=" $(use_with xwidgets)"
	else
		# X11
		myconf+=" --with-x --without-pgtk --without-ns"
		myconf+=" --without-gconf"
		myconf+=" $(use_with gsettings)"
		myconf+=" $(use_with toolkit-scroll-bars)"
		myconf+=" $(use_with xpm)"

		if use xft; then
			myconf+=" --with-xft"
			myconf+=" $(use_with cairo)"
			myconf+=" $(use_with harfbuzz)"
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
			myconf+=" --with-x-toolkit=gtk3 $(use_with xwidgets)"
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
	fi

	if use gui; then
		# Common flags recognised for all GUIs
		myconf+=" $(use_with gif)"
		myconf+=" $(use_with jpeg)"
		myconf+=" $(use_with png)"
		myconf+=" $(use_with svg rsvg)"
		myconf+=" $(use_with tiff)"
		myconf+=" $(use_with webp)"
		myconf+=" $(use_with imagemagick)"
	fi

	if tc-is-cross-compiler; then
		# Configure a CBUILD directory when cross-compiling to make tools
		mkdir "${S}-build" && pushd "${S}-build" >/dev/null || die
		ECONF_SOURCE="${S}" econf_build --without-all --without-x-toolkit
		popd >/dev/null || die
		# Don't try to execute the binary for dumping during the build
		myconf+=" --with-dumping=none"
	elif use m68k; then
		# Workaround for https://debbugs.gnu.org/44531
		myconf+=" --with-dumping=unexec"
	else
		myconf+=" --with-dumping=pdumper"
	fi

	econf \
		--program-suffix="-${EMACS_SUFFIX}" \
		--includedir="${EPREFIX}"/usr/include/${EMACS_SUFFIX} \
		--infodir="${EPREFIX}"/usr/share/info/${EMACS_SUFFIX} \
		--localstatedir="${EPREFIX}"/var \
		--enable-locallisppath="${EPREFIX}/etc/emacs:${EPREFIX}${SITELISP}" \
		--without-compress-install \
		--without-hesiod \
		--without-pop \
		--with-file-notification=$(usev inotify || usev gfile || echo no) \
		--with-pdumper \
		$(use_enable acl) \
		$(use_with dbus) \
		$(use_with dynamic-loading modules) \
		$(use_with games gameuser ":gamestat") \
		$(use_with gmp libgmp) \
		$(use_with gpm) \
		$(use_with jit native-compilation aot) \
		$(use_with json) \
		$(use_with kerberos) $(use_with kerberos kerberos5) \
		$(use_with lcms lcms2) \
		$(use_with libxml2 xml2) \
		$(use_with mailutils) \
		$(use_with selinux) \
		$(use_with sqlite sqlite3) \
		$(use_with ssl gnutls) \
		$(use_with systemd libsystemd) \
		$(use_with threads) \
		$(use_with tree-sitter) \
		$(use_with wide-int) \
		${myconf}
}

src_compile() {
	if tc-is-cross-compiler; then
		# Build native tools for compiling lisp etc.
		emake -C "${S}-build" src
		emake lib	   # Cross-compile dependencies first for timestamps
		# Save native build tools in the cross-directory
		cp "${S}-build"/lib-src/make-{docfile,fingerprint} lib-src || die
		# Specify the native Emacs to compile lisp
		emake -C lisp all EMACS="${S}-build/src/emacs"
	fi

	emake
}

src_test() {
	# List .el test files with a comment above listing the exact
	# subtests which caused failure. Elements should begin with a %.
	# e.g. %lisp/gnus/mml-sec-tests.el.
	local exclude_tests=(
		# Reason: not yet known
		# mml-secure-en-decrypt-{1,2,3,4}
		# mml-secure-find-usable-keys-{1,2}
		# mml-secure-key-checks
		# mml-secure-select-preferred-keys-4
		# mml-secure-sign-verify-1
		%lisp/gnus/mml-sec-tests.el

		# Reason: permission denied on /nonexistent
		# (vc-*-bzr only fails if breezy is installed, as they
		# try to access cache dirs under /nonexistent)
		#
		# rmail-undigest-test-multipart-mixed-digest
		# rmail-undigest-test-rfc1153-less-strict-digest
		# rmail-undigest-test-rfc1153-sloppy-digest
		# rmail-undigest-test-rfc934-digest
		# vc-test-bzr02-state
		# vc-test-bzr05-rename-file
		# vc-test-bzr06-version-diff
		# vc-bzr-test-bug9781
		%lisp/mail/undigest-tests.el
		%lisp/vc/vc-tests.el
		%lisp/vc/vc-bzr-tests.el

		# Reason: fails if bubblewrap (bwrap) is installed
		# "bwrap: setting up uid map: Permission denied"
		#
		# bytecomp-tests--dest-mountpoint
		%lisp/emacs-lisp/bytecomp-tests.el
	)

	# See test/README for possible options
	emake \
		EMACS_TEST_VERBOSE=1 \
		EXCLUDE_TESTS="${exclude_tests[*]}" \
		TEST_BACKTRACE_LINE_LENGTH=nil \
		check
}

src_install() {
	emake DESTDIR="${D}" NO_BIN_LINK=t BLESSMAIL_TARGET= install

	mv "${ED}"/usr/bin/{emacs-${FULL_VERSION}-,}${EMACS_SUFFIX} || die
	mv "${ED}"/usr/share/man/man1/{emacs-,}${EMACS_SUFFIX}.1 || die
	mv "${ED}"/usr/share/metainfo/{emacs-,}${EMACS_SUFFIX}.metainfo.xml || die

	# move info dir to avoid collisions with the dir file generated by portage
	mv "${ED}"/usr/share/info/${EMACS_SUFFIX}/dir{,.orig} || die
	touch "${ED}"/usr/share/info/${EMACS_SUFFIX}/.keepinfodir
	docompress -x /usr/share/info/${EMACS_SUFFIX}/dir.orig

	# movemail must be setgid mail
	if ! use mailutils; then
		fowners root:mail /usr/libexec/emacs/${FULL_VERSION}/${CHOST}/movemail
		fperms 2751 /usr/libexec/emacs/${FULL_VERSION}/${CHOST}/movemail
	fi

	# avoid collision between slots, see bug #169033 e.g.
	rm "${ED}"/usr/share/emacs/site-lisp/subdirs.el || die
	rm -rf "${ED}"/usr/share/{applications,icons} || die
	rm -rf "${ED}/usr/$(get_libdir)/systemd" || die
	rm -rf "${ED}"/var || die

	# remove unused <version>/site-lisp dir
	rm -rf "${ED}"/usr/share/emacs/${FULL_VERSION}/site-lisp || die

	# remove COPYING file (except for etc/COPYING used by describe-copying)
	rm "${ED}"/usr/share/emacs/${FULL_VERSION}/lisp/COPYING || die

	if use systemd; then
		insinto /usr/lib/systemd/user
		sed -e "/^##/d" \
			-e "/^ExecStart/s,emacs,${EPREFIX}/usr/bin/${EMACS_SUFFIX}," \
			-e "/^ExecStop/s,emacsclient,${EPREFIX}/usr/bin/&-${EMACS_SUFFIX}," \
			etc/emacs.service | newins - ${EMACS_SUFFIX}.service
		assert
	fi

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

	dodoc README BUGS CONTRIBUTE

	if use gui && use aqua; then
		dodir /Applications/Gentoo
		rm -rf "${ED}"/Applications/Gentoo/${EMACS_SUFFIX^}.app || die
		mv nextstep/Emacs.app \
			"${ED}"/Applications/Gentoo/${EMACS_SUFFIX^}.app || die
	fi

	local DOC_CONTENTS="You can set the version to be started by
		/usr/bin/emacs through the Emacs eselect module, which also
		redirects man and info pages. Therefore, several Emacs versions can
		be installed at the same time. \"man emacs.eselect\" for details.
		\\n\\nIf you upgrade from a previous major version of Emacs, then
		it is strongly recommended that you use app-admin/emacs-updater
		to rebuild all byte-compiled elisp files of the installed Emacs
		packages."
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
	tc-is-cross-compiler && DOC_CONTENTS+="\\n\\nEmacs did not write
		a portable dump file due to being cross-compiled.
		To create this file at run time, execute the following command:
		\\n${EMACS_SUFFIX} --batch -Q --eval='(dump-emacs-portable
		\"/usr/libexec/emacs/${FULL_VERSION}/${CHOST}/emacs.pdmp\")'"
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
	else
		eselect emacs update ifunset
	fi
}

pkg_postrm() {
	elisp-site-regen
	eselect emacs update ifunset
}

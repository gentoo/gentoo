# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic font greadme optfeature pam strip-linguas systemd xdg-utils

DESCRIPTION="Modular screen saver and locker for the X Window System"
HOMEPAGE="https://www.jwz.org/xscreensaver/"
SRC_URI="
	https://www.jwz.org/xscreensaver/${P}.tar.gz
	logind-idle-hint? (
		https://github.com/Flowdalic/xscreensaver/commit/e79e2f41be3367c196899ef2f38ab97436fa1a65.patch ->
			${PN}-6.12-logind-idle-hint.patch
	)
	systemd? (
		https://github.com/Flowdalic/xscreensaver/commit/376b07ec76cfe1070f498773aaec8fd7030593af.patch ->
			${PN}-6.07-xscreensaver.service-start-with-no-splash.patch
	)
"

S="${WORKDIR}/${PN}-$(ver_cut 1-2)"
# Font license mapping for folder ./hacks/fonts/ as following:
#   clacon.ttf       -- MIT
#   gallant12x22.ttf -- BSD
#   luximr.ttf       -- bh-luxi (package media-fonts/font-bh-ttf)
#   OCRA.ttf         -- freely redistributable
#   SpecialElite.ttf -- Apache-2.0
LICENSE="BSD fonts? ( MIT freedist Apache-2.0 ) systemd? ( ISC )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="elogind ffmpeg fonts +gdk-pixbuf gdm +gtk jpeg +locking logind-idle-hint new-login offensive pam +perl +png selinux suid systemd xinerama wayland"
REQUIRED_USE="
	?? ( elogind systemd )
	pam? ( locking )
	logind-idle-hint? ( || ( elogind systemd ) )
"

COMMON_DEPEND="
	>=dev-libs/libxml2-2.4.6:=
	x11-apps/appres
	x11-apps/xwininfo
	x11-libs/libX11
	x11-libs/libXext
	>=x11-libs/libXft-2.1.0
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXt
	virtual/glu
	virtual/opengl
	elogind? ( sys-auth/elogind )
	gdk-pixbuf? ( >=x11-libs/gdk-pixbuf-2.42.0:2[jpeg?] )
	gtk? ( >=x11-libs/gtk+-3.0.0:3[X,wayland?] )
	ffmpeg? ( >=media-video/ffmpeg-6.1:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	locking? ( virtual/libcrypt:= )
	new-login? (
		gdm? ( gnome-base/gdm )
		!gdm? ( || ( x11-misc/lightdm lxde-base/lxdm ) )
	)
	pam? ( sys-libs/pam )
	png? ( media-libs/libpng:= )
	systemd? ( >=sys-apps/systemd-221:= )
	xinerama? ( x11-libs/libXinerama )
	wayland? ( >=dev-libs/wayland-1.8 )
"
# For USE="perl" see output of `qlist xscreensaver | grep '\(bin\|misc\)' | xargs grep '::'`
RDEPEND="
	${COMMON_DEPEND}
	sys-apps/attr
	x11-misc/xdg-utils
	perl? (
		dev-lang/perl
		dev-perl/HTML-Parser
		dev-perl/LWP-Protocol-https
		dev-perl/libwww-perl
	)
	selinux? ( sec-policy/selinux-xscreensaver )
	wayland? ( gui-apps/grim )
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/intltool
	app-alternatives/bc
	sys-devel/gettext
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-5.31-pragma.patch
	"${FILESDIR}"/${PN}-6.01-gentoo.patch
	"${FILESDIR}"/${PN}-6.07-gcc.patch
	"${FILESDIR}"/${PN}-6.01-configure.ac-sandbox.patch
	"${FILESDIR}"/${PN}-6.01-without-gl-makefile.patch
	"${FILESDIR}"/${PN}-6.01-non-gtk-install.patch
	"${FILESDIR}"/${PN}-6.01-configure-install_sh.patch
	"${FILESDIR}"/${PN}-6.03-without-gl-configure.patch
	"${FILESDIR}"/${PN}-6.05-remove-update-icon-cache.patch
	"${FILESDIR}"/${PN}-6.05-r2-configure-exit-codes.patch
	"${FILESDIR}"/${PN}-6.07-allow-no-pam.patch
	"${FILESDIR}"/${PN}-6.07-fix-desktop-files.patch
	"${FILESDIR}"/${PN}-6.14-ffmpeg.patch
)

DOCS=( README{,.hacking} )

# see https://bugs.gentoo.org/898328
QA_CONFIG_IMPL_DECL_SKIP=( getspnam_shadow )

src_prepare() {
	default

	# bug #896440
	mv po/ca.po po/ca.po.old || die
	iconv -f ISO-8859-15 -t UTF-8 po/ca.po.old >po/ca.po || die

	sed -i configure.ac -e '/^ALL_LINGUAS=/d' || die

	if use systemd; then
		# Causes "Failed to enable unit: Cannot alias xscreensaver.service as org.jwz.xscreensaver."
		# after "systemctl --user enable xscreensaver".
		sed -i -e '/^Alias=org.jwz.xscreensaver.service/d' \
			driver/xscreensaver.service.in || die

		eapply "${DISTDIR}/${PN}-6.07-xscreensaver.service-start-with-no-splash.patch"
	fi

	strip-linguas -i po/
	export ALL_LINGUAS="${LINGUAS}"

	if use new-login && ! use gdm; then #392967
		sed -i \
			-e "/default_l.*1/s:gdmflexiserver -ls:${EPREFIX}/usr/libexec/lightdm/&:" \
			configure{,.ac} || die
	fi

	# We are patching driver/XScreenSaver.ad.in, so let's delete the
	# header generated from it so that it gets back in sync during build:
	rm driver/XScreenSaver_ad.h || die

	if ! use offensive; then
		sed -i \
			-e '/boobies/d;/boobs/d;/cock/d;/pussy/d;/viagra/d;/vibrator/d' \
			hacks/barcode.c || die
		sed -i \
			-e 's|erect penis|shuffle board|g' \
			-e 's|flaccid penis|flaccid anchor|g' \
			-e 's|vagina|engagement ring|g' \
			-e 's|Penis|Shuttle|g' \
			hacks/glx/glsnake.c || die
		sed -i \
			's| Stay.*fucking mask\.$||' \
			hacks/glx/covid19.man \
			hacks/config/covid19.xml || die
		sed -i \
			-e 's|Ass |Dumb |g' \
			-e 's|Buttcorn|Blue Corn|g' \
			-e 's| dick||gi' \
			-e 's| shit||g' \
			hacks/bsod.c || die
		eapply "${FILESDIR}/xscreensaver-6.05-teach-handsy-some-manners.patch"
	fi

	if use logind-idle-hint; then
		eapply "${DISTDIR}/${PN}-6.12-logind-idle-hint.patch"
	fi

	config_rpath_update "${S}"/config.rpath

	# Must be eauto*re*conf, to force the rebuild
	eautoreconf
}

src_configure() {
	if use ppc || use ppc64; then
		filter-flags -maltivec -mabi=altivec
		append-flags -U__VEC__
	fi

	unset BC_ENV_ARGS #24568

	# WARNING: This is NOT a normal autoconf script
	# Some of the --with options are NOT standard, and expect "--with-X=no" rather than "--without-X"
	ECONF_OPTS=(
		$(use_enable locking)
		$(use_with elogind)
		$(use_with gdk-pixbuf pixbuf)
		$(use_with gtk)
		$(use_with new-login login-manager)
		$(use_with pam)
		$(use_with suid setuid-hacks)
		$(use_with systemd)
		$(use_with xinerama xinerama-ext)
		$(use_with wayland)
		--with-jpeg=$(usex jpeg yes no)
		--with-record-animation=$(usex ffmpeg yes no)
		--with-png=$(usex png yes no)
		--with-xft=yes
		--with-app-defaults="${EPREFIX}"/usr/share/X11/app-defaults
		--with-configdir="${EPREFIX}"/usr/share/${PN}/config
		--with-dpms-ext
		--with-hackdir="${EPREFIX}"/usr/$(get_libdir)/misc/${PN}
		--with-randr-ext
		--with-text-file="${EPREFIX}"/etc/gentoo-release
		--with-xdbe-ext
		--with-xinput-ext
		--with-xkb-ext
		--with-xshm-ext
		--without-gle
		--without-gles
		--without-glx
		--without-kerberos
		--without-motif
		--with-proc-oom
		--x-includes="${EPREFIX}"/usr/include
		--x-libraries="${EPREFIX}"/usr/$(get_libdir)
	)
	# WARNING: This is NOT a normal autoconf script
	econf "${ECONF_OPTS[@]}"
}

src_compile() {
	# stock target is "default", which is broken in some releases.
	emake all
}

src_install() {
	use pam && dodir /etc/pam.d/
	emake install_prefix="${D}" DESTDIR="${D}" GTK_SHAREDIR="${installprefix}"/usr/share/xscreensaver install

	if use fonts; then
		# Do not duplicate font Luxi Mono (of package media-fonts/font-bh-ttf)
		rm -v "${ED}${FONTDIR}"/luximr.ttf || die

		font_xfont_config
	else
		rm -rfv "${ED}${FONTDIR}" || die #812473
	fi

	einstalldocs

	if use pam; then
		fperms 755 /usr/bin/${PN}
		pamd_mimic_system ${PN} auth
	fi

	# bugs #809599, #828869
	if ! use gtk; then
		rm "${ED}/usr/bin/xscreensaver-demo" || die
	fi

	if use systemd; then
		systemd_douserunit "${ED}/usr/share/${PN}/xscreensaver.service"
	fi
	# Makefile installs xscreensaver.service regardless of
	# --without-systemd, and if USE=systemd, we will have installed the
	# unit file already.
	rm "${ED}/usr/share/${PN}/xscreensaver.service" || die

	# bug #885989
	fperms 4755 /usr/$(get_libdir)/misc/xscreensaver/xscreensaver-auth

	if ! { use png || use gdk-pixbuf; }; then
		greadme_stdin --append <<-EOF
		Xscreensaver was built without any means to support image manipulation
		(i.e. with neither USE=gtk-pixbuf or USE=png. Several screensavers
		will likely just fail to work without it and several others will
		have diminished appearance like displaying a checkerboard pattern
		instead of an image. It is strongly recommended to enable at least one
		of those flags.

		EOF
	elif ! use gdk-pixbuf; then
		greadme_stdin --append <<-EOF
		Xscreensaver was built with png support only. This means that most of
		screensavers won't be able to use images in any other formats. It is
		recommended to enable USE=gtk-pixbuf.

		EOF
	fi

	if ! use jpeg; then
		greadme_stdin --append <<-EOF
		Xscreensaver was built without jpeg support. This mean that
		'webcollage' screensaver will be considerably slower. Enable
		USE=jpeg if that will become an issue.

		EOF
	fi

	if use gtk; then
		greadme_stdin --append <<-EOF
		You can configure xscreensaver via 'xscreensaver-settings'.

		EOF
	else
		greadme_stdin --append <<-EOF
		Since xscreensaver had been built without USE=gtk
		'xscreensaver-settings' was not installed. Hence the only
		way to configure it is via some third-party utilities or
		directly via configuration file '~/.xscreensaver'.

		EOF
	fi

	if use wayland; then
		greadme_stdin --append <<-EOF
		WARNING: Wayland support is preliminary. It does not lock and you need
		a supported compositor, like:

		 *  kde-plasma/kwin
		 *  gui-wm/sway
		 *  gui-wm/hyprland
		 *  gui-wm/wayfire
		 *  gui-wm/labwc
		EOF
	fi
}

pkg_postinst() {
	use fonts && font_pkg_postinst

	greadme_pkg_postinst

	optfeature_header 'Additional dependencies for specific screensavers'
	optfeature 'vidwhacker' 'media-libs/netpbm[jpeg,png] virtual/imagemagick-tools' \
			'media-libs/netpbm[jpeg,png] media-libs/libjpeg-turbo  media-gfx/fbida'
	optfeature 'webcollage' 'virtual/imagemagick-tools[jpeg,png] x11-apps/xdpyinfo'

	optfeature_header 'Fonts'
	optfeature 'Bitmap fonts 75dpi' media-fonts/font-adobe-75dpi
	optfeature 'Bitmap fonts 100dpi' media-fonts/font-adobe-100dpi
	optfeature 'Truetype font Luxi Mono' media-fonts/font-bh-ttf

	xdg_icon_cache_update
}

pkg_postrm() {
	use fonts && font_pkg_postrm
	xdg_icon_cache_update
}

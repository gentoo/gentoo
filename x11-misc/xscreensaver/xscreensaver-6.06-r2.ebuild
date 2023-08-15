# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic font optfeature pam strip-linguas systemd xdg-utils

DESCRIPTION="Modular screen saver and locker for the X Window System"
HOMEPAGE="https://www.jwz.org/xscreensaver/"
SRC_URI="
	https://www.jwz.org/xscreensaver/${P}.tar.gz
	logind-idle-hint? (
		https://github.com/Flowdalic/xscreensaver/commit/59e7974c42dc08411c9af2a3a644a582c2116f46.patch ->
			${PN}-6.06-logind-idle-hint.patch
	)
"

# Font license mapping for folder ./hacks/fonts/ as following:
#   clacon.ttf       -- MIT
#   gallant12x22.ttf -- unclear, hence dropped
#   luximr.ttf       -- bh-luxi (package media-fonts/font-bh-ttf)
#   OCRAStd.otf      -- unclear, hence dropped
#   SpecialElite.ttf -- Apache-2.0
LICENSE="BSD fonts? ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="elogind fonts gdm gles glx jpeg +locking logind-idle-hint new-login offensive pam +perl selinux suid systemd xinerama"
REQUIRED_USE="
	gles? ( !glx )
	?? ( elogind systemd )
	pam? ( locking )
	logind-idle-hint? ( || ( elogind systemd ) )
"

COMMON_DEPEND="
	>=dev-libs/libxml2-2.4.6
	x11-apps/appres
	x11-apps/xwininfo
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXt
	x11-libs/libXxf86vm
	elogind? ( sys-auth/elogind )
	x11-libs/gdk-pixbuf-xlib
	>=x11-libs/gdk-pixbuf-2.42.0:2
	>=x11-libs/gtk+-3.0.0:3
	jpeg? ( media-libs/libjpeg-turbo:= )
	locking? ( virtual/libcrypt:= )
	new-login? (
		gdm? ( gnome-base/gdm )
		!gdm? ( || ( x11-misc/lightdm lxde-base/lxdm ) )
	)
	virtual/glu
	virtual/opengl
	pam? ( sys-libs/pam )
	media-libs/libpng:=
	systemd? ( >=sys-apps/systemd-221 )
	>=x11-libs/libXft-2.1.0
	xinerama? ( x11-libs/libXinerama )
"
# For USE="perl" see output of `qlist xscreensaver | grep bin | xargs grep '::'`
RDEPEND="
	${COMMON_DEPEND}
	media-gfx/fbida
	perl? (
		dev-lang/perl
		dev-perl/libwww-perl
		virtual/perl-Digest-MD5
	)
	selinux? ( sec-policy/selinux-xscreensaver )
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/intltool
	sys-devel/bc
	sys-devel/gettext
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-5.31-pragma.patch
	"${FILESDIR}"/${PN}-6.01-gentoo.patch
	"${FILESDIR}"/${PN}-5.45-gcc.patch
	"${FILESDIR}"/${PN}-6.01-configure.ac-sandbox.patch
#	"${FILESDIR}"/${PN}-6.01-without-gl-makefile.patch
#	"${FILESDIR}"/${PN}-6.01-non-gtk-install.patch
	"${FILESDIR}"/${PN}-6.01-configure-install_sh.patch
#	"${FILESDIR}"/${PN}-6.03-without-gl-configure.patch
	"${FILESDIR}"/${PN}-6.05-remove-update-icon-cache.patch
#	"${FILESDIR}"/${PN}-6.05-r2-configure-exit-codes.patch
#	"${FILESDIR}"/${PN}-6.05-get-dirs-from-gtk3.0-in-configure.patch
	"${FILESDIR}"/${PN}-6.06-service-remove-Alias-org.jwz.xscreensav.patch
	"${FILESDIR}"/${PN}-6.06-service-start-xscreensaver-with-no-splash.patch
)

DOCS=( README{,.hacking} )

# see https://bugs.gentoo.org/898328
QA_CONFIG_IMPL_DECL_SKIP=( getspnam_shadow )

src_prepare() {
	default

	sed -i configure.ac -e '/^ALL_LINGUAS=/d' || die
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
		eapply "${FILESDIR}/xscreensaver-6.05-teach-handsy-some-manners.patch"
	fi

	if use logind-idle-hint; then
		eapply "${DISTDIR}/${PN}-6.06-logind-idle-hint.patch"
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

	# /proc/interrupts won't always have the keyboard bits needed
	# Not clear this does anything in 6.03+(?) but let's keep it for now in case.
	# (See also: configure argument)
	export ac_cv_have_proc_interrupts=yes

	# WARNING: This is NOT a normal autoconf script
	# Some of the --with options are NOT standard, and expect "--with-X=no" rather than "--without-X"
	ECONF_OPTS=(
		$(use_enable locking)
		$(use_with elogind)
		--with-pixbuf
		$(use_with gles)
		$(use_with glx)
		--with-gtk
		$(use_with new-login login-manager)
		$(use_with pam)
		$(use_with suid setuid-hacks)
		$(use_with systemd)
		$(use_with xinerama xinerama-ext)
		--with-jpeg=$(usex jpeg yes no)
		--with-png=yes
		--with-xft=yes
		--with-app-defaults="${EPREFIX}"/usr/share/X11/app-defaults
		--with-configdir="${EPREFIX}"/usr/share/${PN}/config
		--with-dpms-ext
		--with-hackdir="${EPREFIX}"/usr/$(get_libdir)/misc/${PN}
		--with-proc-interrupts
		--with-randr-ext
		--with-text-file="${EPREFIX}"/etc/gentoo-release
		--with-xdbe-ext
		--with-xf86gamma-ext
		--with-xf86vmode-ext
		--with-xinput-ext
		--with-xkb-ext
		--with-xshm-ext
		--without-gle
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
		# Do not install fonts with unclear licensing
		rm -v "${ED}${FONTDIR}"/{gallant12x22.ttf,OCRAStd.otf} || die

		# Do not duplicate font Luxi Mono (of package media-fonts/font-bh-ttf)
		rm -v "${ED}${FONTDIR}"/luximr.ttf || die

		font_xfont_config
	else
		rm -v "${ED}${FONTDIR}"/*.{ttf,otf} || die
		rmdir -v "${ED}${FONTDIR}" || die #812473
	fi

	einstalldocs

	if use pam; then
		fperms 755 /usr/bin/${PN}
		pamd_mimic_system ${PN} auth
	fi

	# bugs #809599, #828869
	#if ! use gtk; then
	#	rm "${ED}/usr/bin/xscreensaver-demo" || die
	#fi
	if use systemd; then
		systemd_douserunit "${ED}/usr/share/${PN}/xscreensaver.service"
	fi
	# Makefile installs xscreensaver.service regardless of
	# --without-systemd, and if USE=systemd, we will have installed the
	# unit file already.
	rm "${ED}/usr/share/${PN}/xscreensaver.service" || die

	# bug #885989
	fperms 4755 /usr/$(get_libdir)/misc/xscreensaver/xscreensaver-auth
}

pkg_postinst() {
	use fonts && font_pkg_postinst

	# bug #811885
	if ! use glx; then
		elog "Enable USE='glx' if OpenGL screensavers are crashing."
	fi

	optfeature 'Bitmap fonts 75dpi' media-fonts/font-adobe-75dpi
	optfeature 'Bitmap fonts 100dpi' media-fonts/font-adobe-100dpi
	optfeature 'Truetype font Luxi Mono' media-fonts/font-bh-ttf

	xdg_icon_cache_update
}

pkg_postrm() {
	use fonts && font_pkg_postrm
	xdg_icon_cache_update
}

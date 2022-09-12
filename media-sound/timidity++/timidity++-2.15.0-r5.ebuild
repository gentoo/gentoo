# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop elisp-common flag-o-matic systemd xdg

MY_PV="${PV/_/-}"
MY_P="TiMidity++-${MY_PV}"

DESCRIPTION="A handy MIDI to WAV converter with OSS and ALSA output support"
HOMEPAGE="http://timidity.sourceforge.net/"
SRC_URI="mirror://sourceforge/timidity/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="alsa ao emacs flac gtk jack motif nas ncurses ogg oss selinux slang speex tk vorbis X Xaw3d"

REQUIRED_USE="tk? ( X )"

DEPEND="
	alsa? ( media-libs/alsa-lib )
	ao? ( >=media-libs/libao-0.8.5 )
	emacs? ( >=app-editors/emacs-23.1:* )
	flac? ( media-libs/flac:= )
	gtk? ( x11-libs/gtk+:2 )
	jack? ( virtual/jack )
	motif? ( >=x11-libs/motif-2.3:0 )
	nas? ( >=media-libs/nas-1.4 )
	ncurses? ( sys-libs/ncurses:0= )
	ogg? ( media-libs/libogg )
	slang? ( sys-libs/slang )
	speex? ( media-libs/speex )
	tk? ( dev-lang/tk:= )
	vorbis? ( media-libs/libvorbis )
	X? (
		media-libs/libpng:=
		x11-libs/libX11
		x11-libs/libXext
		Xaw3d? ( x11-libs/libXaw3d )
		!Xaw3d? ( x11-libs/libXaw )
	)
"

RDEPEND="
	${DEPEND}
	acct-group/audio
	acct-group/nobody
	acct-user/timidity
	app-eselect/eselect-timidity
	alsa? ( media-sound/alsa-utils )
	selinux? ( sec-policy/selinux-timidity )
"

PDEPEND="|| ( media-sound/timidity-eawpatches media-sound/timidity-freepats )"

SITEFILE=50${PN}-gentoo.el

DOCS=( AUTHORS ChangeLog NEWS README "${FILESDIR}"/timidity.cfg-r1 )

PATCHES=(
	"${FILESDIR}"/${PN}-2.14.0-params.patch
	"${FILESDIR}"/${PN}-2.14.0-ar.patch
	"${FILESDIR}"/${PN}-2.14.0-configure-flags.patch
	"${FILESDIR}"/${PN}-2.15.0-pkg-config.patch
	"${FILESDIR}"/${PN}-2.14.0-CVE-2017-1154{6,7}.patch
	"${FILESDIR}"/${PN}-2.15.0-lto-workaround.patch
	"${FILESDIR}"/${PN}-2.15.0-clang-15-configure.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	export EXTRACFLAGS="${CFLAGS}" #385817

	local audios
	# List by preference
	local xaw_provider=$(usex Xaw3d 'xaw3d' 'xaw')

	# configure workarounds: configure.in here is written for an old version
	# of autoconf and upstream seems quite dead.
	#
	# 1. Avoid janky configure test breaking
	# ```checking for sys/wait.h that is POSIX.1 compatible... yes
	# ./configure: 7995: test: =: unexpected operator```
	export ac_cv_header_sys_time_h=yes
	#
	# 2. And yes, we expect standard header locations (this configure test is flaky for us too)
	# This avoids a bunch of implicit decl. errors which only happen with USE=-Xaw3d(?!)
	append-cppflags -DSTDC_HEADERS

	local myeconfargs=(
		--localstatedir=/var/state/${PN}
		--with-module-dir="${EPREFIX}/usr/share/timidity"
		--with-lispdir="${SITELISP}/${PN}"
		--with-elf
		--enable-server
		--enable-network
		--enable-dynamic
		--enable-vt100
		--enable-spline=cubic
		$(use_enable emacs)
		$(use_enable slang)
		$(use_enable ncurses)
		$(use_with X x)
		$(use_enable X spectrogram)
		$(use_enable X wrd)
		$(use_enable X xskin)
		$(use_enable X xaw)
		$(use_enable gtk)
		$(use_enable tk tcltk)
		$(use_enable motif)
		$(use_with Xaw3d xawlib ${xaw_provider})
	)

	use flac && audios+=",flac"
	use speex && audios+=",speex"
	use vorbis && audios+=",vorbis"
	use ogg && audios+=",ogg"
	use oss && audios+=",oss"
	use jack && audios+=",jack"
	use ao && audios+=",ao"

	if use nas; then
		audios+=",nas"
		myeconfargs+=(
			--with-nas-library="/usr/$(get_libdir)/libaudio.so"
			--with-x
		)
		use X || ewarn "Basic X11 support will be enabled because required by nas."
	fi

	if use alsa; then
		audios+=",alsa"
		myeconfargs+=(
			--with-default-output=alsa
			--enable-alsaseq
		)
	fi

	if use motif; then
		myeconfargs+=(
			--with-x
		)
		use X || ewarn "Basic X11 support will be enabled because required by motif."
	fi

	# needs to come after all audios have been collected
	myeconfargs+=(
		--enable-audio=${audios}
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs

	# these are only for the ALSA sequencer mode
	if use alsa; then
		newconfd "${FILESDIR}"/conf.d.timidity.2 timidity
		newinitd "${FILESDIR}"/init.d.timidity.4 timidity

		systemd_dounit "${FILESDIR}"/timidity.service
	fi

	insinto /etc
	newins "${FILESDIR}"/timidity.cfg-r1 timidity.cfg

	dodir /usr/share/timidity
	dosym ../../../etc/timidity.cfg /usr/share/timidity/timidity.cfg

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	doicon "${FILESDIR}"/timidity.xpm
	newmenu "${FILESDIR}"/timidity.desktop.2 timidity.desktop

	# Order of preference: gtk, X (Xaw), ncurses, slang
	# Do not create menu item for terminal ones
	local interface="-id"
	local terminal="true"
	local nodisplay="true"
	if use gtk || use X; then
		interface="-ia"
		terminal="false"
		nodisplay="false"
		use gtk && interface="-ig"
	elif use ncurses || use slang; then
		local interface="-is"
		use ncurses && interface="-in"
	fi
	sed -e "s/Exec=timidity/Exec=timidity ${interface}/" \
		-e "s/Terminal=.*/Terminal=${terminal}/" \
		-e "s/NoDisplay=.*/NoDisplay=${nodisplay}/" \
		-i "${ED}"/usr/share/applications/timidity.desktop || die
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "A timidity config file has been installed in /etc/timidity.cfg."
	elog "Do not edit this file as it will interfere with the eselect timidity tool."
	elog "The tool 'eselect timidity' can be used to switch between installed patchsets."

	if use alsa; then
		elog "An init script for the alsa timidity sequencer has been installed."
		elog "If you wish to use the timidity virtual sequencer, edit /etc/conf.d/timidity"
		elog "and run 'rc-update add timidity <runlevel> && /etc/init.d/timidity start'"
	fi

	if use sparc; then
		elog "Only saving to wave file and ALSA soundback has been tested working."
	fi

	xdg_pkg_postinst
}

pkg_postrm() {
	use emacs && elisp-site-regen
	xdg_pkg_postrm
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils flag-o-matic multilib pam

DESCRIPTION="A modular screen saver and locker for the X Window System"
HOMEPAGE="http://www.jwz.org/xscreensaver/"
SRC_URI="
	http://www.jwz.org/xscreensaver/${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="gdm jpeg new-login opengl pam +perl selinux suid xinerama"

COMMON_DEPEND="
	>=gnome-base/libglade-2
	dev-libs/libxml2
	media-libs/netpbm
	x11-apps/appres
	x11-apps/xwininfo
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXrandr
	x11-libs/libXt
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	jpeg? ( virtual/jpeg:0 )
	new-login? (
		gdm? ( gnome-base/gdm )
		!gdm? ( || ( x11-misc/lightdm kde-base/kdm ) )
		)
	opengl? (
		virtual/glu
		virtual/opengl
	)
	pam? ( virtual/pam )
	xinerama? ( x11-libs/libXinerama )
"
# For USE="perl" see output of `qlist xscreensaver | grep bin | xargs grep '::'`
RDEPEND="
	${COMMON_DEPEND}
	perl? (
		dev-lang/perl
		dev-perl/libwww-perl
		virtual/perl-Digest-MD5
	)
	selinux? ( sec-policy/selinux-xscreensaver )
"
DEPEND="
	${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/bc
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/recordproto
	x11-proto/scrnsaverproto
	x11-proto/xextproto
	x11-proto/xf86miscproto
	x11-proto/xf86vidmodeproto
	xinerama? ( x11-proto/xineramaproto )
"

src_prepare() {
	sed -i configure.in -e '/^ALL_LINGUAS=/d' || die
	strip-linguas -i po/
	export ALL_LINGUAS="${LINGUAS}"

	if use new-login && ! use gdm; then #392967
		sed -i \
			-e "/default_l.*1/s:gdmflexiserver -ls:${EPREFIX}/usr/libexec/lightdm/&:" \
			configure{,.in} || die
	fi

	epatch \
		"${FILESDIR}"/${PN}-5.33-gentoo.patch \
		"${FILESDIR}"/${PN}-5.05-interix.patch \
		"${FILESDIR}"/${PN}-5.20-blurb-hndl-test-passwd.patch \
		"${FILESDIR}"/${PN}-5.20-test-passwd-segv-tty.patch \
		"${FILESDIR}"/${PN}-5.20-tests-miscfix.patch \
		"${FILESDIR}"/${PN}-5.28-comment-style.patch \
		"${FILESDIR}"/${PN}-5.31-pragma.patch \
		"${FILESDIR}"/${PN}-5.35-comments.patch

	eapply_user

	eautoconf
	eautoheader
}

src_configure() {
	if use ppc || use ppc64; then
		filter-flags -maltivec -mabi=altivec
		append-flags -U__VEC__
	fi

	unset BC_ENV_ARGS #24568
	export RPM_PACKAGE_VERSION=no #368025

	econf \
		$(use_with jpeg) \
		$(use_with new-login login-manager) \
		$(use_with opengl gl) \
		$(use_with pam) \
		$(use_with suid setuid-hacks) \
		$(use_with xinerama xinerama-ext) \
		--enable-locking \
		--with-configdir="${EPREFIX}"/usr/share/${PN}/config \
		--with-dpms-ext \
		--with-gtk \
		--with-hackdir="${EPREFIX}"/usr/$(get_libdir)/misc/${PN} \
		--with-pixbuf \
		--with-proc-interrupts \
		--with-randr-ext \
		--with-text-file="${EPREFIX}"/etc/gentoo-release \
		--with-x-app-defaults="${EPREFIX}"/usr/share/X11/app-defaults \
		--with-xdbe-ext \
		--with-xf86gamma-ext \
		--with-xf86vmode-ext \
		--with-xinput-ext \
		--with-xshm-ext \
		--without-gle \
		--without-kerberos \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	emake install_prefix="${D}" install

	dodoc README{,.hacking}

	use pam && fperms 755 /usr/bin/${PN}
	pamd_mimic_system ${PN} auth

	rm -f "${ED}"/usr/share/${PN}/config/{electricsheep,fireflies}.xml
}

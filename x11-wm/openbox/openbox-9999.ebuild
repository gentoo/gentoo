# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit multilib autotools ltprune python-r1 eutils

DESCRIPTION="A standards compliant, fast, light-weight, extensible window manager"
HOMEPAGE="http://openbox.org/"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.openbox.org/dana/openbox"
	SRC_URI="branding? (
	https://dev.gentoo.org/~hwoarang/distfiles/surreal-gentoo.tar.gz )"
else
	SRC_URI="http://openbox.org/dist/openbox/${P}.tar.gz
	branding? ( https://dev.gentoo.org/~hwoarang/distfiles/surreal-gentoo.tar.gz )"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="3"
IUSE="branding debug imlib nls session startup-notification static-libs svg xdg"
REQUIRED_USE="xdg? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/glib:2
	>=dev-libs/libxml2-2.0
	>=media-libs/fontconfig-2
	x11-libs/cairo
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXt
	>=x11-libs/pango-1.8[X]
	imlib? ( media-libs/imlib2 )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	svg? ( gnome-base/librsvg:2 )
	xdg? (
		${PYTHON_DEPS}
		dev-python/pyxdg[${PYTHON_USEDEP}]
	)
	"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}/${PN}-3.5.2-gnome-session.patch" )

src_prepare() {
	default
	sed -i \
		-e "s:-O0 -ggdb ::" \
		-e 's/-fno-strict-aliasing//' \
		"${S}"/m4/openbox.m4 || die
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable nls) \
		$(use_enable imlib imlib2) \
		$(use_enable svg librsvg) \
		$(use_enable startup-notification) \
		$(use_enable session session-management) \
		--with-x
}

src_install() {
	dodir /etc/X11/Sessions
	echo "/usr/bin/openbox-session" > "${ED}/etc/X11/Sessions/${PN}"
	fperms a+x /etc/X11/Sessions/${PN}
	emake DESTDIR="${D}" install
	if use branding; then
		insinto /usr/share/themes
		doins -r "${WORKDIR}"/Surreal_Gentoo
		# make it the default theme
		sed -i \
			-e "/<theme>/{n; s@<name>.*</name>@<name>Surreal_Gentoo</name>@}" \
			"${D}"/etc/xdg/openbox/rc.xml \
			|| die "failed to set Surreal Gentoo as the default theme"
	fi
	use static-libs || prune_libtool_files --all
	if use xdg ; then
		python_replicate_script "${ED}"/usr/libexec/openbox-xdg-autostart
	else
		rm "${ED}"/usr/libexec/openbox-xdg-autostart || die
	fi
}

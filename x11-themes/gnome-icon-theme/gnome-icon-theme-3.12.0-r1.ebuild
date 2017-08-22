# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GNOME default icon theme"
HOMEPAGE="https://www.gnome.org/ https://people.freedesktop.org/~jimmac/icons/#git"

SRC_URI="${SRC_URI}
	branding? ( https://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )"

LICENSE="|| ( LGPL-3 CC-BY-SA-3.0 )
	branding? ( CC-BY-SA-4.0 )"
SLOT="0"
IUSE="branding"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	if use branding; then
		for i in 16 22 24 32 48; do
			cp "${WORKDIR}"/tango-gentoo-v1.1/${i}x${i}/gentoo.png \
			"${S}"/gnome//${i}x${i}/places/start-here.png \
			|| die "Copying gentoo logos failed"
		done
	fi

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-icon-mapping \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}

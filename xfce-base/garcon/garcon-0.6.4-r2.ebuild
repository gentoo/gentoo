# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Xfce's freedesktop.org specification compatible menu implementation library"
HOMEPAGE="https://docs.xfce.org/xfce/exo/start"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="-gtk2"

RDEPEND=">=dev-libs/glib-2.30:=
	>=x11-libs/gtk+-3.20:3=
	>=xfce-base/libxfce4util-4.12:=
	gtk2? (
		>=x11-libs/gtk+-2.24:2=
		<xfce-base/libxfce4ui-4.15:=[gtk2(+),gtk3(+)]
	)
	!gtk2? (
		>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	)"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog HACKING NEWS README STATUS TODO )

src_configure() {
	local myconf=(
		$(use_enable gtk2)
		$(use_enable gtk2 libxfce4ui)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

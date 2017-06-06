# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit virtualx xdg-utils

DESCRIPTION="A flexible, easy-to-use configuration management system for Xfce"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug test"

RDEPEND=">=dev-libs/dbus-glib-0.98:=
	>=dev-libs/glib-2.30:=
	>=xfce-base/libxfce4util-4.10:="
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

# this revision does not install the daemon -- use :1 for that
RDEPEND="${RDEPEND}
	xfce-base/xfconf:1"
DEPEND="${DEPEND}
	test? ( xfce-base/xfconf:1 )"

src_configure() {
	local myconf=(
		--disable-perl-bindings
		$(use_enable debug checks)
	)

	xdg_environment_reset
	econf "${myconf[@]}"
}

src_compile() {
	emake SUBDIRS="common xfconf"
}

my_test() {
	local out=$("${EPREFIX}/usr/$(get_libdir)/xfce4/xfconf/xfconfd" --daemon) || return 1
	eval "${out}"

	local ret=0
	nonfatal emake -C tests check || ret=1

	kill "${XFCONFD_PID}" || ewarn "Unable to kill xfconfd"
	return "${ret}"
}

src_test() {
	virtx my_test
}

src_install() {
	emake DESTDIR="${D}" SUBDIRS="common xfconf" install
	einstalldocs
	find "${D}" -type f -name '*.la' -delete || die
}

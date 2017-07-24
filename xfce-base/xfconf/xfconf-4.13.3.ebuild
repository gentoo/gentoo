# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit virtualx xdg-utils

DESCRIPTION="A flexible, easy-to-use configuration management system for Xfce"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug perl"

RDEPEND=">=dev-libs/glib-2.30:=
	>=xfce-base/libxfce4util-4.10:=
	perl? (
		dev-lang/perl:=[-build(-)]
		dev-perl/glib-perl
	)"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	perl? (
		dev-perl/ExtUtils-Depends
		dev-perl/ExtUtils-PkgConfig
	)"

src_configure() {
	local myconf=(
		$(use_enable perl perl-bindings)
		$(use_enable debug checks)
		--with-perl-options=INSTALLDIRS=vendor
	)

	xdg_environment_reset
	econf "${myconf[@]}"
}

src_compile() {
	emake OTHERLDFLAGS="${LDFLAGS}"
}

my_test() {
	local out=$(./xfconfd/xfconfd --daemon) || return 1
	eval "${out}"

	local ret=0
	nonfatal emake check || ret=1

	kill "${XFCONFD_PID}" || ewarn "Unable to kill xfconfd"
	return "${ret}"
}

src_test() {
	virtx my_test
}

src_install() {
	default
	find "${D}" -type f -name '*.la' -delete || die

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -delete || die
		find "${ED}" -depth -mindepth 1 -type d -empty -delete || die
	fi
}

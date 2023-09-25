# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A small, fast, full-featured window manager for X"
HOMEPAGE="https://github.com/bbidulock/blackboxwm"
SRC_URI="https://github.com/bbidulock/blackboxwm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug nls static-libs truetype"

RDEPEND="x11-libs/libXft
	x11-libs/libXt
	x11-libs/libX11
	nls? ( >=sys-devel/gettext-0.20 )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND=">=sys-devel/autoconf-2.71
	virtual/pkgconfig"

S="${WORKDIR}"/blackboxwm-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-0.77-gcc12-time.patch
)

src_prepare() {
	sed -e '/AC_DISABLE_SHARED/d' -i configure.ac || die
	default
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/X11/${PN} \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable truetype xft)
}

src_install() {
	exeinto /etc/X11/Sessions
	newexe - ${PN} <<-EOF
	#!/bin/sh
	${PN}
	EOF

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"

	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog* COMPLIANCE README* TODO

	find "${D}" -name '*.la' -delete || die
	use static-libs || rm "${D}"/usr/$(get_libdir)/libbt.a || die
}

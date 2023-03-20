# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal optfeature

DESCRIPTION="Abstraction library between applications and audio visualisation plugins"
HOMEPAGE="http://libvisual.org/"
SRC_URI="https://github.com/Libvisual/libvisual/releases/download/${P}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0.4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug nls threads"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libvisual-0.4/libvisual/lvconfig.h
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--enable-lv-tool \
		--disable-examples \
		$(use_enable nls) \
		$(use_enable threads) \
		$(use_enable debug)
}

multilib_src_install_all() {
	einstalldocs

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	optfeature_header "Libvisual relies on plugins; consider also installing:"
	optfeature operability  media-plugins/libvisual-plugins
	optfeature projectm     media-plugins/libvisual-projectm
}

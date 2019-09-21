# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal

DESCRIPTION="Embedded Linux Library provides core, low-level functionality for system daemons"
HOMEPAGE="https://01.org/ell"
SRC_URI="https://mirrors.edge.kernel.org/pub/linux/libs/${PN}/${P}.tar.xz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="glib pie"

RDEPEND="
	glib? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	append-cflags "-fsigned-char" #662694
	local myeconfargs=(
		$(use_enable glib)
		$(use_enable pie)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	local DOCS=( ChangeLog README )
	einstalldocs

	find "${ED}" -name "*.la" -delete || die
}

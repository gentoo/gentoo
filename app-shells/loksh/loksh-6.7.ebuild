# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

# https://github.com/dimkr/loksh/issues/16
LOLIBC_COMMIT="f6bbd5bae97e58d0be6ea9fbbe5131853d5b0b70"

DESCRIPTION="Linux port of OpenBSD's ksh"
HOMEPAGE="https://github.com/dimkr/loksh"
SRC_URI="https://github.com/dimkr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dimkr/lolibc/archive/${LOLIBC_COMMIT}.tar.gz -> lolibc-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="sys-libs/ncurses:0="
BDEPEND="virtual/pkgconfig"
RDEPEND="${DEPEND}
	!app-shells/ksh"

src_prepare() {
	default
	rmdir "${S}/subprojects/lolibc" || die
	mv -v "${WORKDIR}/lolibc-${LOLIBC_COMMIT}" "${S}/subprojects/lolibc" || die
	sed -i "/install_dir/s@loksh@${PF}@" meson.build || die
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Library that provides direct access to the IEEE 1394 bus"
HOMEPAGE="https://ieee1394.wiki.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/libs/ieee1394/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}

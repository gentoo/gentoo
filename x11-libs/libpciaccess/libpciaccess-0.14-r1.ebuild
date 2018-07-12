# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Library providing generic access to the PCI bus and devices"
HOMEPAGE="https://www.x.org/wiki/"
SRC_URI="mirror://xorg/lib/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs zlib"

DEPEND="
	!<x11-base/xorg-server-1.5
	zlib? (	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	sys-apps/hwids
	x11-misc/util-macros
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.14-install-scanpci.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local econfargs=(
		$(use_with zlib)
		$(use_enable static-libs static)
		--with-pciids-path=${EPREFIX%/}/usr/share/misc
	)

	ECONF_SOURCE="${S}" econf "${econfargs[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

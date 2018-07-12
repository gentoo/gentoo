# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="X.Org Inter-Client Exchange library"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"
SRC_URI="mirror://xorg/lib/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="doc ipv6 static-libs"

RDEPEND="
	x11-base/xorg-proto
	x11-libs/xtrans
	elibc_glibc? ( dev-libs/libbsd )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local econfargs=(
		$(use_enable ipv6)
		$(use_enable doc docs)
		$(use_enable doc specs)
		$(use_with doc xmlto)
		$(use_enable static-libs static)
		--without-fop
	)

	ECONF_SOURCE="${S}" econf "${econfargs[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

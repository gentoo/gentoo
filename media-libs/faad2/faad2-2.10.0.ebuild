# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="https://www.audiocoding.com/faad2.html"
SRC_URI="https://github.com/knik0/faad2/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="digitalradio static-libs"

RDEPEND=""
DEPEND=""

DOCS=( AUTHORS ChangeLog NEWS README TODO )

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	sed -i -e 's:iquote :I:' libfaad/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--without-xmms
		$(use_with digitalradio drm)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	# do not build the frontend for non default abis
	if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
		sed -i -e 's/frontend//' Makefile || die
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
	einstalldocs
}

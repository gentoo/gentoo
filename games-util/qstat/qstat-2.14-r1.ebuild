# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Server statics collector supporting many FPS games"
HOMEPAGE="https://github.com/Unity-Technologies/qstat"
SRC_URI="https://github.com/Unity-Technologies/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc64 x86"
IUSE="debug"

RDEPEND="!sys-cluster/torque"

DOCS=( CHANGES.txt COMPILE.txt template/README.txt )

PATCHES=(
	"${FILESDIR}"/"${P}"-gcc-10.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	strnstr #bug #899024, there's fallback implementation
)

src_prepare() {
	default
	eautoreconf

	# bug #530952
	sed -i -e 's/strndup/l_strndup/g' qstat.c || die
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default
	dosym qstat /usr/bin/quakestat

	docinto html
	dodoc template/*.html qstatdoc.html
}

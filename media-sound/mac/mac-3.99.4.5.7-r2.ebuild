# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic versionator

MY_PV=$(version_format_string '$1.$2-u$3-b$4')
PATCH=s$(get_version_component_range 5)
MY_P=${PN}-${MY_PV}-${PATCH}

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="http://etree.org/shnutils/shntool/"
SRC_URI="http://etree.org/shnutils/shntool/support/formats/ape/unix/${MY_PV}-${PATCH}/${MY_P}.tar.gz"

LICENSE="mac"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE="cpu_flags_x86_mmx static-libs"

RDEPEND=""
DEPEND="sys-apps/sed
	cpu_flags_x86_mmx? ( dev-lang/yasm )"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-gcc6.patch )

HTML_DOCS=( src/Readme.htm )
DOCS=( AUTHORS ChangeLog NEWS TODO README src/History.txt src/Credits.txt ChangeLog.shntool )

RESTRICT="mirror"

src_prepare() {
	default
	sed -i -e 's:-O3::' configure || die
}

src_configure() {
	append-cppflags -DSHNTOOL
	use cpu_flags_x86_mmx && append-ldflags -Wl,-z,noexecstack

	econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx assembly)
}

src_install() {
	default

	insinto /usr/include/${PN}
	doins src/MACLib/{BitArray,UnBitArrayBase,Prepare}.h #409435

	find "${D}" -name '*.la' -delete || die
}

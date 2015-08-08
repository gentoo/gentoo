# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic versionator

MY_PV=$(version_format_string '$1.$2-u$3-b$4')
PATCH=s$(get_version_component_range 5)
MY_P=${PN}-${MY_PV}-${PATCH}

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="http://etree.org/shnutils/shntool/"
SRC_URI="http://etree.org/shnutils/shntool/support/formats/ape/unix/${MY_PV}-${PATCH}/${MY_P}.tar.gz"

LICENSE="mac"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="cpu_flags_x86_mmx static-libs"

RDEPEND=""
DEPEND="sys-apps/sed
	cpu_flags_x86_mmx? ( dev-lang/yasm )"

S=${WORKDIR}/${MY_P}

RESTRICT="mirror"

src_prepare() {
	sed -i -e 's:-O3::' configure || die
}

pkg_setup() {
	append-cppflags -DSHNTOOL
	use cpu_flags_x86_mmx && append-ldflags -Wl,-z,noexecstack
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx assembly)
}

src_install() {
	default

	insinto /usr/include/${PN}
	doins src/MACLib/{BitArray,UnBitArrayBase,Prepare}.h #409435

	dodoc ChangeLog.shntool src/*.txt
	dohtml src/Readme.htm

	prune_libtool_files --all
}

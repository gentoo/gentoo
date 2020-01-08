# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs multilib-minimal

S="${WORKDIR}/cmt/src"
MY_P="cmt_src_${PV}"

DESCRIPTION="CMT (computer music toolkit) LADSPA library plugins"
HOMEPAGE="http://www.ladspa.org/"
SRC_URI="http://www.ladspa.org/download/${MY_P}.tgz"

KEYWORDS="alpha amd64 ~arm ~arm64 hppa ppc ppc64 sparc x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=">=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]"
RDEPEND=""

src_prepare() {
	sed -i \
		-e "/^CFLAGS/ s/-O3/${CFLAGS}/" \
		-e 's|/usr/local/include||g' \
		-e 's|/usr/local/lib||g' makefile \
			|| die "sed makefile failed"
	sed -i -e "s/^CXXFLAGS*/CXXFLAGS = ${CXXFLAGS} \$(INCLUDES) -Wall -fPIC\n#/" \
		"${S}/makefile" || die "sed makefile failed (CXXFLAGS)"

	cd "${S}" || die
	epatch "${FILESDIR}/${P}-mallocstdlib.patch"
	epatch "${FILESDIR}/${P}-respect-ldflags.patch"
	epatch "${FILESDIR}/${P}-sa.patch"
	use elibc_Darwin && epatch "${FILESDIR}/${P}-darwin.patch"
	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CXX
	emake PLUGIN_LIB="cmt.so"
}

multilib_src_install() {
	insopts -m755
	insinto /usr/$(get_libdir)/ladspa
	doins *.so
}

multilib_src_install_all() {
	insinto /usr/share/ladspa/rdf/
	doins "${FILESDIR}/cmt.rdf"

	dodoc ../README
	dohtml ../doc/*
}

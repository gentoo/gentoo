# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 toolchain-funcs

DESCRIPTION="New type of presentation program"
HOMEPAGE="http://www.srcf.ucam.org/~dmi1000/multitalk/"
SRC_URI="http://www.srcf.ucam.org/~dmi1000/multitalk/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples latex"

DEPEND="
	>=media-libs/libsdl-1.2.7
	>=media-libs/sdl-gfx-2.0.13
	>=media-libs/sdl-image-1.2.3
	>=media-libs/sdl-ttf-2.0.6
"
RDEPEND="${DEPEND}"
BDEPEND="
	latex? (
		virtual/imagemagick-tools
		virtual/latex-base
	)
"

DOC_CONTENTS="
You will have to source /etc/profile (or logout and back in).
See also /usr/share/doc/${PF}/${PN}.pdf.
"

src_prepare() {
	default
	sed -i \
		-e "s:g++:$(tc-getCXX) ${CXXFLAGS}:" \
		-e "s:-L\${HOME}/lib:${LDFLAGS}:" \
		Makefile || die "sed for Makefile failed."
}

src_install() {
	dodir /usr/bin
	emake SYSPREFIX="${D}/usr" install

	insinto /usr/share/${PN}/examples
	doins examples/about.{graph,talk}

	doenvd "${FILESDIR}/99multitalk"

	dodoc README docs/Changelog docs/multitalk.pdf

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

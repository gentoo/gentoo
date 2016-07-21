# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils multilib virtualx

DESCRIPTION="Tk-based Calendar program"
HOMEPAGE="https://launchpad.net/ical-tcl"
SRC_URI="https://launchpad.net/ical-tcl/3.x/${PV}/+download/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	dev-lang/tcl:0
	dev-lang/tk:0
	"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-newtcl.patch \
		"${FILESDIR}"/${P}-makefile.patch

	sed -i \
		-e 's:8.4 8.3:8.6 8.5 8.4 8.3:g' \
		-e 's:sys/utsname.h limits.h::' \
		configure.in || die

	sed -i \
		-e 's:mkdir:mkdir -p:' \
		-e "/LIBDIR =/s:lib:$(get_libdir):" \
		-e '/MANDIR =/s:man:share/man:' \
		Makefile.in || die

	mv configure.{in,ac} || die

	eautoconf
}

src_compile() {
	emake OPTF="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_test() {
	[[ ${EUID} != 0 ]] && Xemake check
}

src_install() {
	emake prefix="${D}/usr" install

	DOCS=( ANNOUNCE *README RWMJ-release-notes.txt TODO )
	HTML_DOCS=( {.,doc}/*.html )
	einstalldocs

	rm -f "${D}"/usr/$(get_libdir)/ical/v3.0/contrib/README || die
}

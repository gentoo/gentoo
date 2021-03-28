# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MYP=Herwig++-${PV}

DESCRIPTION="High-Energy Physics event generator"
HOMEPAGE="https://herwig.hepforge.org/"
SRC_URI="https://www.hepforge.org/archive/herwig/${MYP}.tar.bz2"
S="${WORKDIR}/${MYP}"

SLOT="0/15"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="c++11 fastjet static-libs"

# >sci-physics/looptools-2.8 leads to misoperation
# and failing tests (it lacks some symbols)
RDEPEND="
	dev-libs/boost:0=
	sci-libs/gsl:0=
	<=sci-physics/looptools-2.8:0=
	~sci-physics/thepeg-1.9.2:0=
	fastjet? ( sci-physics/fastjet:0= )"
DEPEND="
	${RDEPEND}
	>=sys-devel/boost-m4-0.4_p20160328
"

src_prepare() {
	default

	eapply -p0 "${FILESDIR}"/${PN}-2.6.3-looptools.patch
	eapply "${FILESDIR}"/${PN}-2.7.1-fix-boost-1.67.patch

	# fixes bug 570458, which is due to an outdated bundled boost.m4
	rm m4/boost.m4 || die

	find -name 'Makefile.am' -exec \
		sed -i -e '1ipkgdatadir=$(datadir)/herwig++' {} \; || die

	eautoreconf
}

src_configure() {
	if use prefix ; then
		append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/ThePEG"
	fi

	local myeconfargs=(
		--with-boost="${EPREFIX}"/usr
		--with-thepeg="${EPREFIX}"/usr
		$(use_enable c++11 stdcxx11)
		$(use_with fastjet fastjet "${EPREFIX}"/usr)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	sed -i -e "s|${ED}||g" "${ED}"/usr/share/herwig++/defaults/PDF.in || die
	sed -i -e "s|${ED}||g" "${ED}"/usr/share/herwig++/HerwigDefaults.rpo || die
}

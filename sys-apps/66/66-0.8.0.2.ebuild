# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Package name: sys-apps/66
DESCRIPTION="Init system and dependency management over s6"
HOMEPAGE="https://web.obarun.org/software/66/0.8.0.2/index/"
SRC_URI="https://git.obarun.org/Obarun/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man doc static static-libs init"

DEPEND=" >=dev-libs/skalibs-2.14.3.0 >=sys-libs/oblibs-0.3.2.1 "
BDEPEND="
man? ( app-text/lowdown )
doc? ( app-text/lowdown )
"
RDEPEND=" >=dev-lang/execline-2.9.6.1 >=sys-apps/s6-2.13.1.0
!static? ( ${DEPEND} )
"

src_configure() {
 local econfargs=(
 "--with-sysdeps=${EPREFIX}/usr/$(get_libdir)/skalibs"
 "--dynlibdir=${EPREFIX}/usr/$(get_libdir)"
 "--libdir=${EPREFIX}/usr/$(get_libdir)/${PN}"
 )

 if use static
 then econfargs+=(
 "--enable-allstatic"
 "--disable-shared"
 "--enable-static-libc"
 ); fi
 if use static-libs; then econfargs+=("--enable-static"); fi

 econf ${econfargs[@]}
}

src_install() {
 emake DESTDIR="${D}" install

 # Moving the doc paths to conform to gentoo's FHS
 if ! use doc; then rm -fr "${ED}/usr/share/doc/*"
 else mv "${ED}/usr/share/doc/${PN}/${PV}" "${ED}/usr/share/doc/${PF}"; fi
 if ! use man; then rm -fr "${ED}/usr/share/man/*"; fi
 if ! use init; then rm -f "${ED}/usr/bin/init"; fi
}

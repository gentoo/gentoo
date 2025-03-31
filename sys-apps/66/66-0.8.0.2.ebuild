EAPI=8

# Package name: sys-apps/66
DESCRIPTION="Init system and dependency management over s6"
HOMEPAGE="https://web.obarun.org/software/${PN}/${PV}/index/"
SRC_URI="https://git.obarun.org/Obarun/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="+man doc strip -static -static-libs -init"

# sys-libs/oblibs not yet upstream
RDEPEND=">=dev-libs/skalibs-2.14.3.0 >=dev-lang/execline-2.9.6.1 >=sys-apps/s6-2.13.1.0 >=sys-libs/oblibs-0.3.2.1
"

# Documentation
BDEPEND=">=dev-libs/skalibs-2.14.3.0 >=sys-libs/oblibs-0.3.1.0
man? ( app-text/lowdown )
doc? ( app-text/lowdown )
"

src_configure() {
 local LOCAL_EXTRA_ECONF=(
 "--with-sysdeps=/usr/$(get_libdir)/skalibs"
 "--dynlibdir=/usr/$(get_libdir)"
 "--libdir=/usr/$(get_libdir)/${PN}"
 )

 if use static
 then LOCAL_EXTRA_ECONF+=(
 "--enable-allstatic"
 "--disable-shared"
 "--enable-static-libc"
 ); fi
 if use static-libs; then LOCAL_EXTRA_ECONF+=("--enable-static"); fi

 econf ${LOCAL_EXTRA_ECONF[@]}
}

src_install() {
 if use strip; then emake strip; fi

 emake DESTDIR="${D}" install

 if ! use doc; then rm -fr "${D}/usr/share/doc/*"; fi
 if ! use man; then rm -fr "${D}/usr/share/man/*"; fi
 if ! use init; then rm -f "${D}/usr/bin/init"; fi
}

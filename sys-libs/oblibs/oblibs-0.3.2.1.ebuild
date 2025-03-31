EAPI=8

DESCRIPTION="Library with convenience functions used mainly by sys-apps/66"
HOMEPAGE="https://web.obarun.org/software/"
SRC_URI="https://git.obarun.org/Obarun/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="*"
IUSE="-static -static-libs"

RDEPEND=">=dev-libs/skalibs-2.14.3.0 >=dev-lang/execline-2.9.6.1"
BDEPEND=">=dev-libs/skalibs-2.14.3.0"

src_configure() {
 local LOCAL_EXTRA_ECONF=(
 "--with-sysdeps=/usr/$(get_libdir)/skalibs"
 "--dynlibdir=/usr/$(get_libdir)"
 "--libdir=/usr/$(get_libdir)/${PN}"
 )
 # Need to replace "/usr" with "${EPREFIX}" if required for ebuild portability.

 if use static; then LOCAL_EXTRA_ECONF+=("--enable-allstatic --disable-shared"); fi
 if use static-libs; then LOCAL_EXTRA_ECONF+=("--enable-static"); fi

 econf ${LOCAL_EXTRA_ECONF[@]}
}

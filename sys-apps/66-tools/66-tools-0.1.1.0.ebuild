EAPI=8

# Package name: sys-apps/66-tools
DESCRIPTION="Set of helper tools for execline and 66"
HOMEPAGE="https://web.obarun.org/software/${PN}/${PV}/index/"
SRC_URI="https://git.obarun.org/Obarun/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="*"
IUSE="+man doc strip -static -static-libs +elogind dbus"

RDEPEND=">=dev-libs/skalibs-2.14.3.0 >=dev-lang/execline-2.9.6.1 >=sys-libs/oblibs-0.3.1.0
dbus? (
 >=sys-apps/66-0.8.0.1
 sys-apps/dbus-broker[-launcher]
 elogind? ( sys-auth/elogind )
 !elogind? ( sys-libs/basu )
)
"

# Documentation
BDEPEND=">=dev-libs/skalibs-2.14.3.0 >=sys-libs/oblibs-0.3.1.0
dbus? (
 elogind? ( sys-auth/elogind )
 !elogind? ( sys-libs/basu )
)
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

 if use dbus; then
  elog "Enabled dbus requiring dbus-broker; disable USE=dbus for ${CATEGORY}/${PN} if you don't want sys-apps/dbus-broker"
  if use elogind
  then LOCAL_EXTRA_ECONF+=("--enable-dbus=elogind"); elog "Using sys-auth/elogind for sd-bus"
  else LOCAL_EXTRA_ECONF+=("--enable-dbus=basu"); elog "Using sys-libs/basu for sd-bus"
  fi
 fi
 elog "The original sd-bus via sys-apps/systemd not supported for obvious reasons..."

 econf ${LOCAL_EXTRA_ECONF[@]}
}

src_install() {
 if use strip; then emake strip; fi
 emake DESTDIR="${D}" install
 if ! use doc; then rm -fr "${D}/usr/share/doc/*"; fi
 if ! use man; then rm -fr "${D}/usr/share/man/*"; fi
}

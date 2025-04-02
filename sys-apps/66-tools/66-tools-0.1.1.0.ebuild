# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Package name: sys-apps/66-tools
DESCRIPTION="Set of helper tools for execline and 66"
HOMEPAGE="https://web.obarun.org/software/66-tools/0.1.1.0/index/"
SRC_URI="https://git.obarun.org/Obarun/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man doc static static-libs elogind dbus"

DEPEND=" >=dev-libs/skalibs-2.14.3.0 >=sys-libs/oblibs-0.3.1.0
dbus? (
 elogind? ( sys-auth/elogind )
 !elogind? ( sys-libs/basu )
)
"

RDEPEND=" >=dev-lang/execline-2.9.6.1
!static? ( ${DEPEND} )
"
# dbus? ( sys-apps/dbus-broker[-launcher] ) has been omitted for now
# It mangles dependencies; Causes issues on musl etc..
# The frontend will also be included in this package soon.

# Documentation
BDEPEND="
man? ( app-text/lowdown )
doc? ( app-text/lowdown )
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

 if use dbus; then
  elog "USE=dbus enabled; Provides 66-dbus-launch command which replaces dbus-broker-launcher in sys-apps/dbus-broker[launcher]"
  elog "66-dbus-launch supports all the features like dbus-activation (using 66 itself) etc..."
  elog "which the original systemd-dependant dbus-broker-launcher did"
  elog "Install sys-apps/dbus-broker[-launcher] to use it; Pre-written frontends coming soon!"
  if use elogind
  then econfargs+=("--enable-dbus=elogind"); elog "Using sys-auth/elogind for sd-bus"
  else econfargs+=("--enable-dbus=basu"); elog "Using sys-libs/basu for sd-bus"
  fi
 fi
 elog "The original sd-bus via sys-apps/systemd not supported for obvious reasons..."

 econf ${econfargs[@]}
}

src_install() {
 emake DESTDIR="${D}" install
 if ! use doc; then rm -fr "${ED}/usr/share/doc/*"
 else mv "${ED}/usr/share/doc/${PN}/${PV}" "${ED}/usr/share/doc/${PF}"; fi
 if ! use man; then rm -fr "${ED}/usr/share/man/*"; fi
}

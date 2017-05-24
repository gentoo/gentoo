# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils toolchain-funcs user

DESCRIPTION="busybox variant of findutils"
HOMEPAGE="www.busybox.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"


DEPEND=" sys-apps/busybox !sys-apps/findutils "

src_install() {
  dodir /usr/bin

  einfo "Symlinking find to ${ROOT}bin/busybox"
  ln -s "${ROOT}"/bin/busybox "${D}""${ROOT}"usr/bin/find

  einfo "Symlinking xargs to ${ROOT}bin/busybox"
  ln -s "${ROOT}"/bin/busybox "${D}""${ROOT}"usr/bin/xargs
}

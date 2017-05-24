# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils toolchain-funcs user

DESCRIPTION="busybox variant of grep"
HOMEPAGE="www.busybox.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"


DEPEND=" sys-apps/busybox !sys-apps/grep "

src_install() {
  dodir /bin

  einfo "Symlinking grep to ${ROOT}bin/busybox"
  ln -s "${ROOT}"bin/busybox "${D}""${ROOT}"bin/grep

  einfo "Symlinking egrep to ${ROOT}bin/busybox"
  ln -s "${ROOT}"bin/busybox "${D}""${ROOT}"bin/egrep

  einfo "Symlinking fgrep to ${ROOT}bin/busybox"
  ln -s "${ROOT}"bin/busybox "${D}""${ROOT}"bin/fgrep
}

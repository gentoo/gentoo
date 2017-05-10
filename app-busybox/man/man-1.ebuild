# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils toolchain-funcs user

DESCRIPTION="Standard commands to read man pages"
HOMEPAGE="www.busybox.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"


DEPEND=" sys-apps/busybox "
RDEPEND="|| ( >=sys-apps/groff-1.19.2-r1 app-doc/heirloom-doctools )
	!sys-apps/man-db
  !sys-apps/man
	"

pkg_setup() {
	enewgroup man 15
	enewuser man 13 -1 /usr/share/man man
}


echoit() { echo "$@" ; "$@" ; }


src_install() {
  keepdir /var/cache/man
  diropts -m0775 -g man
  local mansects=$(grep ^MANSECT "${D}"/etc/man.conf | cut -f2-)
  for x in ${mansects//:/ } ; do
    keepdir /var/cache/man/cat${x}
  done

  dodir /usr/bin

  einfo "Symlinking man to ${ROOT}bin/busybox"
  ln -s "${ROOT}"bin/busybox "${D}""${ROOT}"usr/bin/man
}

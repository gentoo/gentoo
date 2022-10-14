# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages the /bin/sh (POSIX shell) symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="app-eselect/eselect-lib-bin-symlink"

src_install() {
	insinto /usr/share/eselect/modules
	newins - sh.eselect <<-EOF
		# Copyright 1999-2022 Gentoo Authors
		# Distributed under the terms of the GNU General Public License v2

		DESCRIPTION="Manage /bin/sh (POSIX shell) implementations"
		MAINTAINER="mgorny@gentoo.org"
		VERSION="${PV}"

		SYMLINK_PATH=/bin/sh
		SYMLINK_TARGETS=( bash dash lksh mksh )
		SYMLINK_DESCRIPTION='POSIX shell'
		SYMLINK_CRUCIAL=1

		inherit bin-symlink
	EOF
}

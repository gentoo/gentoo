# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit tmpfiles toolchain-funcs

DESCRIPTION="openvz tool and a library to control ploop block devices"
HOMEPAGE="https://wiki.openvz.org/Download/ploop"
SRC_URI="https://download.openvz.org/utils/ploop/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/libxml2"
RDEPEND="${DEPEND}
	sys-block/parted
	sys-fs/e2fsprogs
	sys-process/lsof
	sys-apps/findutils"

PATCHES=(
	"${FILESDIR}"/disable_create_run_dir.patch
	"${FILESDIR}"/${PN}-1.15-makedev-include.patch
)

DOCS=( tools/README )

src_prepare() {
	default

	# Respect CFLAGS and CC, do not add debug by default
	sed -i \
		-e 's|CFLAGS =|CFLAGS +=|' \
		-e '/CFLAGS/s/-g -O0 //' \
		-e '/CFLAGS/s/-O2//' \
		-e 's|CC=|CC?=|' \
		-e 's/-Werror//' \
		-e '/DEBUG=yes/d' \
		-e '/LOCKDIR/s/var/run/' \
		Makefile.inc || die 'sed on Makefile.inc failed'
	# Avoid striping of binaries
	sed -e '/INSTALL/{s: -s::}' -i tools/Makefile || die 'sed on tools/Makefile failed'

	# respect AR and RANLIB, bug #452092
	tc-export AR RANLIB
	sed -i -e 's/ranlib/$(RANLIB)/' lib/Makefile || die 'sed on lib/Makefile failed'
}

src_compile() {
	emake CC="$(tc-getCC)" V=1 $(usex debug 'DEBUG' '' '=yes' '')
}

src_install() {
	emake DESTDIR="${D}" LIBDIR=/usr/$(get_libdir) install
	rm "${ED}"/usr/$(get_libdir)/*.a || die
}

pkg_postinst() {
	tmpfiles_process ploop.conf
}

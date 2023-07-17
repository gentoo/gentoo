# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="de fr pl pt"
PLOCALE_BACKUP="en"
inherit flag-o-matic linux-info toolchain-funcs plocale

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="https://www.ivarch.com/programs/pv.shtml"
SRC_URI="https://www.ivarch.com/programs/sources/${P}.tar.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug nls"

DOCS=( README.md doc/NEWS.md doc/TODO.md )

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # See https://github.com/a-j-wood/pv/issues/69
)

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~SYSVIPC"
		ERROR_SYSVIPC="You will need to enable CONFIG_SYSVIPC in your kernel to use the --remote option."
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default

	sed -i configure -e 's|CFLAGS="-g -Wall"|:|g' || die

	# These should produce the same end result (working `pv`).
	sed -i \
		-e 's:$(LD) $(LDFLAGS) -o:$(AR) rc:' \
		autoconf/make/modules.mk~ || die

	sed -i -e 's:usleep 200000 || ::g' tests/019-remote-cksum || die

	disable_locale() {
		local locale=${1}
		sed -i configure -e "/ALL_LINGUAS=/s:${locale}::g" || die
	}

	plocale_find_changes src/nls '' '.po'
	plocale_for_each_disabled_locale disable_locale
}

src_configure() {
	tc-export AR

	# Workaround for https://github.com/a-j-wood/pv/issues/69
	append-lfs-flags

	econf \
		--enable-lfs \
		$(use_enable debug debugging) \
		$(use_enable nls)
}

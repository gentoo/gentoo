# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Hardware RNG based on CPU timing jitter"
HOMEPAGE="https://github.com/smuellerDD/jitterentropy-library"
SRC_URI="https://github.com/smuellerDD/jitterentropy-library/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# For future reference, tests/raw-entropy/validation-{restart,runtime}
# have a weird license clause where it says:
#   The licensee IS NOT granted permission to redistribute the source code or
#   derivatives of the source code, and the binaries compiled from the source
#   code or its derivatives to any third parties.
# Do not package these two components!
LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="static-libs"

S="${WORKDIR}/${PN}-library-${PV}"

src_prepare() {
	default

	# Disable man page compression on install
	sed -e '/\tgzip.*man/ d' -i Makefile || die
}

src_compile() {
	# Upstream defines some of CFLAGS in the Makefile using '?='
	# This allows those default flags to be overwritten by
	# user-defined CFLAGS. Restore some of the defaults.
	append-cflags '-fwrapv' '-fvisibility=hidden' '-fPIE'
	# Optimizations are not allowed by upstream, which already
	# overrides CFLAGS in Makefile. We need to handle CPPFLAGS here.
	append-cppflags '-O0'
	emake AR="$(tc-getAR)" CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" \
		  LIBDIR="$(get_libdir)" \
		  DESTDIR="${D}" \
		  INSTALL_STRIP="install" \
		  install $(usex static-libs install-static '')
}

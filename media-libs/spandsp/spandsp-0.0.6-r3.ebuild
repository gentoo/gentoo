# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SpanDSP is a library of DSP functions for telephony"
HOMEPAGE="https://www.soft-switch.org/"
SRC_URI="https://www.soft-switch.org/downloads/spandsp/${P/_}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"
IUSE="doc fixed-point cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3"

RDEPEND="media-libs/tiff:=
	media-libs/libjpeg-turbo:="
DEPEND="${RDEPEND}"
BDEPEND="doc? (
	app-text/doxygen
	dev-libs/libxslt
)"

# Enabled implicitly by the build system. Really useless.
REQUIRED_USE="
	cpu_flags_x86_sse3? ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2? ( cpu_flags_x86_sse )
	cpu_flags_x86_sse? ( cpu_flags_x86_mmx )"

S=${WORKDIR}/${PN}-$(ver_cut 1-3)

# TODO:
# there are two tests options: tests and test-data
# 	they need audiofile, fftw, libxml and probably more

src_configure() {
	# Note: flags over sse3 aren't really used -- they're only
	# boilerplate. They also make some silly assumptions, e.g. that
	# every CPU with SSE4* has SSSE3.
	# Reference: https://bugs.funtoo.org/browse/FL-2069.
	# If you want to re-add them, first check if the code started
	# using them. If it did, figure out if the flags can be unbundled
	# from one another. Otherwise, you'd have to do REQUIRED_USE.

	econf \
		$(use_enable doc) \
		$(use_enable fixed-point) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog DueDiligence NEWS README

	find "${ED}" -name '*.la' -delete || die

	if use doc; then
		docinto html
		dodoc -r doc/{api/html/*,t38_manual}
	fi
}

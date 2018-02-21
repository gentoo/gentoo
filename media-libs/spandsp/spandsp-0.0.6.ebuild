# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib versionator

DESCRIPTION="SpanDSP is a library of DSP functions for telephony"
HOMEPAGE="http://www.soft-switch.org/"
SRC_URI="http://www.soft-switch.org/downloads/spandsp/${P/_}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 hppa ia64 ~ppc ~ppc64 x86"
IUSE="doc fixed-point cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 static-libs"

RDEPEND="media-libs/tiff
	 virtual/jpeg"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen
		dev-libs/libxslt )"

# Enabled implicitly by the build system. Really useless.
REQUIRED_USE="
	cpu_flags_x86_sse3? ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2? ( cpu_flags_x86_sse )
	cpu_flags_x86_sse? ( cpu_flags_x86_mmx )"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-3)

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
		--disable-dependency-tracking \
		$(use_enable doc) \
		$(use_enable fixed-point) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable static-libs static)
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog DueDiligence NEWS README

	if ! use static-libs; then
		# remove useless la file when not installing static lib
		rm "${D}"/usr/$(get_libdir)/lib${PN}.la || die "rm failed"
	fi

	if use doc; then
		dohtml -r doc/{api/html/*,t38_manual}
	fi
}

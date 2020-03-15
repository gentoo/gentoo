# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A Markdown-to HTML translator written in C"
HOMEPAGE="http://www.pell.portland.or.us/~orc/Code/discount/"
SRC_URI="http://www.pell.portland.or.us/~orc/Code/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ia64 ppc ppc64 sparc x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

src_prepare() {
	default

	# for QA, we remove the Makefile’s usage of install -s.
	# Drop ldconfig invocation.
	# Force “librarian.sh” to respect LDFLAGS ($FLAGS should have CFLAGS
	# at that point).
	sed -i \
		-e '/INSTALL_PROGRAM/s,\$_strip ,,' \
		-e 's/\(LDCONFIG=\).*/\1:/' \
		-e 's/\(.\)\$FLAGS/& \1$LDFLAGS/' \
		configure.inc || die "sed configure.inc failed"

	# Add LDFLAGS and CPPFLAGS hackily.
	sed -i \
		-e 's/^CC[ \t]*=.*/& $(CPPFLAGS)/' \
		-e 's/^LFLAGS[ \t]*=.*/& $(LDFLAGS)/' \
		Makefile.in || die "Cannot fix LDFLAGS and CPPFLAGS"
}

src_configure() {
	local configure_call=(
		./configure.sh
		--libdir="${EPREFIX}"usr/"$(get_libdir)"
		--prefix="${EPREFIX}"usr
		--mandir="${EPREFIX}"usr/share/man
		--shared
		--pkg-config
		$(usex minimal '' --enable-all-features)
		# Enable deterministic HTML generation behavior. Otherwise, will
		# actually call rand() as part of its serialization code...
		--debian-glitch
	)
	einfo "Running ${configure_call[@]}"
	CC="$(tc-getCC)" \
	"${configure_call[@]}" || die
}

src_install() {
	emake \
		DESTDIR="${D}" \
		$(usex minimal install install.everything) \
		SAMPLE_PFX="${PN}-"

	insinto /usr/$(get_libdir)/pkgconfig
	doins libmarkdown.pc
}

pkg_postinst() {
	if ! use minimal; then
		elog 'Sample binaries with overly-generic names have been'
		elog "prefixed with \"${PN}-\"."
	fi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A Markdown-to HTML translator written in C"
HOMEPAGE="http://www.pell.portland.or.us/~orc/Code/discount/"
SRC_URI="https://github.com/Orc/discount/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2.2.7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
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
}

src_configure() {
	local configure_call=(
		./configure.sh
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--prefix="${EPREFIX}/usr"
		--mandir="${EPREFIX}/usr/share/man"
		--shared
		--pkg-config
		$(usex minimal '' --enable-all-features)
		# Enable deterministic HTML generation behavior. Otherwise, will
		# actually call rand() as part of its serialization code...
		--debian-glitch
	)
	einfo "Running ${configure_call[@]}"
	CC="$(tc-getCC)" AR="$(tc-getAR)" \
	"${configure_call[@]}" || die
}

src_compile() {
	emake libmarkdown
	emake
}

src_install() {
	emake \
		DESTDIR="${D}" \
		$(usex minimal install install.everything) \
		SAMPLE_PFX="${PN}-"
}

pkg_postinst() {
	if ! use minimal; then
		elog 'Sample binaries with overly-generic names have been'
		elog "prefixed with \"${PN}-\"."
	fi
}

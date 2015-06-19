# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/discount/discount-2.1.6-r1.ebuild,v 1.9 2014/01/19 20:05:54 pacho Exp $

EAPI=5

inherit eutils multilib

DESCRIPTION="An implementation of John Gruber's Markdown text to html language written in C"
HOMEPAGE="http://www.pell.portland.or.us/~orc/Code/discount/"
SRC_URI="http://www.pell.portland.or.us/~orc/Code/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="minimal"

src_prepare() {
	epatch "${FILESDIR}"/${P}-portage-multilib-CFLAGS.patch

	# for QA, we remove the Makefile’s usage of install -s.
	# Drop ldconfig invocation.
	# Force “librarian.sh” to respect LDFLAGS ($FLAGS should have CFLAGS
	# at that point).
	sed -i \
		-e '/INSTALL_PROGRAM/s,-s ,,' \
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
	./configure.sh \
		--libdir="${EPREFIX}"usr/"$(get_libdir)" \
		--prefix="${EPREFIX}"usr \
		--mandir="${EPREFIX}"usr/share/man \
		--shared \
		$(usex minimal '' --enable-all-features) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" $(usex minimal install install.everything)

	DISCOUNT_EBUILD_RENAMED_BINARIES=()
	local bin
	for bin in "${ED}"usr/bin/*; do
		[[ ${bin} = */markdown || ${bin} =~ ${PN}[^/]*$ ]] && continue
		DISCOUNT_EBUILD_RENAMED_BINARIES+=(${bin##*/})
		mv "${bin}" "${bin%/*}/${PN}-${bin##*/}" || die
		mv "${ED}"usr/share/man/man1/{,${PN}-}${bin##*/}.1 || die
	done
}

pkg_postinst() {
	if [[ ${DISCOUNT_EBUILD_RENAMED_BINARIES} ]]; then
		local bin
		elog "Some discount binaries with overly-generic names have been"
		elog "prefixed. Please see"
		elog "https://github.com/Orc/discount/issues/81 for discussion."
		for bin in "${DISCOUNT_EBUILD_RENAMED_BINARIES[@]}"; do
			elog "  Renamed '${bin}' to '${PN}-${bin}'."
		done
	fi
}

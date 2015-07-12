# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/discount/discount-2.1.8a.ebuild,v 1.1 2015/07/12 03:59:23 binki Exp $

EAPI=5

inherit eutils multilib

DESCRIPTION="An implementation of John Gruber's Markdown text to html language written in C"
HOMEPAGE="http://www.pell.portland.or.us/~orc/Code/discount/"
SRC_URI="http://www.pell.portland.or.us/~orc/Code/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="minimal"

src_prepare() {
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
	# How econf() handles quoted whitespace. This should go away next
	# release of discount.
	eval "local -a DISCOUNT_EXTRA_CONFIGURE_SH=(${DISCOUNT_EXTRA_CONFIGURE_SH})"

	local configure_call=(
		./configure.sh
		--libdir="${EPREFIX}"usr/"$(get_libdir)"
		--prefix="${EPREFIX}"usr
		--mandir="${EPREFIX}"usr/share/man
		--shared
		$(usex minimal '' --enable-all-features)
		# Because a lot of discount features are exposed through
		# ./configure.sh flags that, in the future, won’t be, I will
		# respect DISCOUNT_EXTRA_CONFIGURE_SH as a workaround pending
		# upstream https://github.com/Orc/discount/issues/124 for bug
		# #554520.
		"${DISCOUNT_EXTRA_CONFIGURE_SH[@]}"
	)
	einfo "Running ${configure_call[@]} || die"
	"${configure_call[@]}" || die
}

src_install() {
	emake \
		DESTDIR="${D}" \
		$(usex minimal install install.everything) \
		SAMPLE_PFX="${PN}-"
}

pkg_postinst() {
	if ! use minimal; then
		elog "Sample binaries with overly-generic names have been"
		elog "prefixed with \"${PN}-\". Please see"
		elog "https://github.com/Orc/discount/issues/81 for discussion."
	fi
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune

DESCRIPTION="Exempi is a port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="https://libopenraw.freedesktop.org/wiki/Exempi"
SRC_URI="https://libopenraw.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="examples static-libs test"

RDEPEND="
	>=dev-libs/expat-2:=
	virtual/libiconv
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	sys-devel/gettext
	test? ( >=dev-libs/boost-1.48 )
"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-2.4.2-iconv.patch
	cp /usr/share/gettext/config.rpath . || die
	eautoreconf
}

src_configure() {
	# Valgrind detection is "disabled" due to bug #295875
	econf \
		$(use_enable static-libs static) \
		$(use_enable test unittest) \
		VALGRIND=""
}

src_install() {
	default
	prune_libtool_files --all

	if use examples; then
		emake -C samples/source distclean
		rm samples/{,source,testfiles}/Makefile* || die
		insinto /usr/share/doc/${PF}/examples
		doins -r samples/*
	fi
}

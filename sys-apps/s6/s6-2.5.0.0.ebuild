# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DESCRIPTION="skarnet.org's small and secure supervision software suite"
HOMEPAGE="https://www.skarnet.org/software/s6/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="static static-libs"

DEPEND=">=sys-devel/make-3.81
	static? (
		>=dev-lang/execline-2.3.0.0[static-libs]
		>=dev-libs/skalibs-2.5.0.0[static-libs]
	)
	!static? (
		>=dev-lang/execline-2.3.0.0[static=]
		>=dev-libs/skalibs-2.5.0.0
	)
"
RDEPEND="
	>=dev-lang/execline-2.3.0.0:=[!static?]
	!static? (
		>=dev-libs/skalibs-2.5.0.0:=
	)
"

DOCS="AUTHORS examples README*"
HTML_DOCS="doc/*"

src_prepare() {
	default

	# Remove QA warning about LDFLAGS addition
	sed -i "s/tryldflag LDFLAGS_AUTO -Wl,--hash-style=both/:/" "${S}/configure" || die
}

src_configure() {
	econf \
		--bindir=/bin \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--with-dynlib=/$(get_libdir) \
		--with-lib=/usr/$(get_libdir)/execline \
		--with-lib=/usr/$(get_libdir)/skalibs \
		--with-sysdeps=/usr/$(get_libdir)/skalibs \
		$(use_enable !static shared) \
		$(use_enable static allstatic) \
		$(use_enable static static-libc) \
		$(use_enable static-libs static)
}

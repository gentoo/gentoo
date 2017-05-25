# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic autotools vcs-snapshot

DESCRIPTION="An Portable Open Source UPnP Development Kit"
HOMEPAGE="http://pupnp.sourceforge.net/"
SRC_URI="https://github.com/mrjimenez/pupnp/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="1.8"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux"
IUSE="debug doc reuseaddr ipv6 static-libs"

DOCS="NEWS README.md ChangeLog"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.0-docs-install.patch
	"${FILESDIR}"/${PN}-1.6.21-cflags.patch
)

src_prepare() {
	default

	# fix tests
	chmod +x ixml/test/test_document.sh || die

	eautoreconf
}

src_configure() {
	use x86-fbsd &&	append-flags -O1
	# w/o docdir to avoid sandbox violations
	econf $(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable reuseaddr) \
		$(use_enable static-libs static) \
		$(use_with doc documentation "${EPREFIX}/usr/share/doc/${PF}")
}

src_install () {
	default
	dobin upnp/sample/.libs/tv_{combo,ctrlpt,device}-1.8
	use static-libs || prune_libtool_files
}

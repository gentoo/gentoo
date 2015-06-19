# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/librra/librra-0.16.ebuild,v 1.1 2012/06/15 08:39:17 ssuominen Exp $

EAPI=4

PYTHON_DEPEND="python? 2:2.7"

inherit python

DESCRIPTION="Implements the RRA protocol, for syncing pre WM-2005 PIM data, and files for all versions"
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python recurrence static-libs"

RDEPEND=">=app-pda/synce-core-0.16[python?]
	>=dev-libs/libmimedir-0.5.1
	python? ( >=dev-python/pyrex-0.9.6 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable recurrence) \
		$(use_enable python python-bindings)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog README TODO
	newdoc lib/README README.lib
	newdoc src/README README.src

	# prune_libtool_files() from eutils.eclass fails wrt #421197
	find "${ED}" -name '*.la' -exec rm -f {} +

	# Always remove static archive from site-packages
	use static-libs && find "${ED}" -name pyrra.a -exec rm -f {} +
}

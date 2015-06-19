# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/hyperdex/hyperdex-1.7.1.ebuild,v 1.1 2015/06/18 02:47:00 patrick Exp $
EAPI=5

# Tests fail, again
RESTRICT="test"

PYTHON_COMPAT=( python2_7)
inherit eutils python-single-r1 autotools

DESCRIPTION="A searchable distributed Key-Value Store"

HOMEPAGE="http://hyperdex.org"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz
	http://dev.gentooexperimental.org/~patrick/autotools-java.tar"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test +python"
# need to add ruby and java useflags too

DEPEND="dev-cpp/glog
	dev-cpp/sparsehash
	dev-libs/cityhash
	dev-libs/libpo6
	dev-libs/libe
	dev-libs/busybee
	dev-libs/popt
	dev-libs/replicant
	dev-libs/libmacaroons
	dev-libs/libtreadstone
	dev-libs/json-c"
RDEPEND="${DEPEND}"

REQUIRED_USE="test? ( python )"

src_prepare() {
	cp "${WORKDIR}/"*.m4 m4/
	sed -i -e 's~json/json.h~json-c/json.h~' configure.ac common/datatype_document.cc daemon/index_document.cc || die "Blergh!"
	eautoreconf
	use python && python-single-r1_pkg_setup
}
src_configure() {
	econf --disable-static \
		$(use_enable python python-bindings)
}

src_install() {
	emake DESTDIR="${D}" install || die "Failed to install"
	newinitd "${FILESDIR}/hyperdex.initd" hyperdex || die "Failed to install init script"
	newconfd "${FILESDIR}/hyperdex.confd" hyperdex || die "Failed to install config file"
	find "${D}" -name '*.la' -exec rm {} \; # bad buildsystem! bad!
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

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
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) test? ( python )"

# Tests fail, still
RESTRICT="test"

DEPEND="
	dev-cpp/glog
	dev-cpp/sparsehash
	dev-libs/cityhash
	>=dev-libs/hyperleveldb-1.2
	>=dev-libs/libpo6-0.8
	>=dev-libs/libe-0.11
	>=dev-libs/busybee-0.7
	dev-libs/popt
	>=dev-libs/replicant-0.8
	>=dev-libs/libmacaroons-0.3
	>=dev-libs/libtreadstone-0.2
	dev-libs/json-c
	python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cp "${WORKDIR}/"*.m4 m4/
	sed -i -e 's~json/json.h~json-c/json.h~' configure.ac common/datatype_document.cc daemon/index_document.cc || die "Blergh!"
	eautoreconf
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

src_test() {
	emake -j1 check
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1 autotools git-r3

DESCRIPTION="A searchable distributed Key-Value Store"

HOMEPAGE="http://hyperdex.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS=""

EGIT_REPO_URI="https://github.com/rescrv/HyperDex.git"

SRC_URI="http://dev.gentooexperimental.org/~patrick/autotools-java.tar"

IUSE="+python"
# need to add ruby and java useflags too
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-cpp/glog
	dev-cpp/sparsehash
	dev-libs/cityhash
	dev-libs/libpo6
	dev-libs/libe
	dev-libs/busybee
	dev-libs/popt
	dev-libs/replicant
	dev-libs/json-c
	python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cd m4; tar xf "${DISTDIR}/autotools-java.tar"
	cd ..
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

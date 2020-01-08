# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils java-pkg-opt-2 flag-o-matic

DESCRIPTION="Proj.4 cartographic projection software"
HOMEPAGE="http://trac.osgeo.org/proj/"
DATUMGRID=${PN}-datumgrid-1.8.zip
SRC_URI="
	http://download.osgeo.org/proj/${P}.tar.gz
	http://download.osgeo.org/proj/${DATUMGRID}
"

LICENSE="MIT"
SLOT="0/15"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="java static-libs"

RDEPEND=""
DEPEND="
	app-arch/unzip
	dev-db/sqlite:3
	java? ( >=virtual/jdk-1.5 )"

src_unpack() {
	unpack ${P}.tar.gz
	unpack ${DATUMGRID}
}

src_configure() {
	if use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		append-cflags "$(java-pkg_get-jni-cflags)"
	fi
	econf \
		$(use_enable static-libs static) \
		$(use_with java jni)
}

src_install() {
	default
	prune_libtool_files
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs eutils java-pkg-opt-2 java-ant-2

MYP="Healpix_${PV}"
MYPF=${MYP}_2015Oct08

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere"
HOMEPAGE="http://healpix.sourceforge.net/"
SRC_URI="mirror://sourceforge/healpix/${MYP}/${MYPF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# might add fortran in the future if requested
IUSE="cxx doc idl java openmp static-libs test"

RDEPEND="
	>=sci-libs/cfitsio-3
	idl? (
		dev-lang/gdl
		sci-astronomy/idlastro )
	java? ( >=virtual/jre-1.6:* )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.6:* test? ( dev-java/ant-junit4:0 ) )"

S="${WORKDIR}/${MYP}"

pkg_pretend() {
	if use cxx && use openmp && [[ $(tc-getCXX)$ == *g++* ]] && [[ ${MERGE_TYPE} != binary ]]; then
		tc-has-openmp || \
			die "You are using gcc but without OpenMP capabilities that you requested"
	fi
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	pushd src/C/autotools > /dev/null
	eautoreconf
	popd > /dev/null
	# why was static-libtool-libs forced?
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		sed -i -e '/-static-libtool-libs/d' Makefile.am || die
		eautoreconf
		popd > /dev/null
	fi
	# duplicate of idlastro (in rdeps)
	rm -r src/idl/zzz_external/astron || die
	mv src/idl/zzz_external/README src/idl/README.external || die
	java-pkg-opt-2_src_prepare
	default
}

src_configure() {
	pushd src/C/autotools > /dev/null
	econf $(use_enable static-libs static)
	popd > /dev/null
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		econf \
			--disable-native-optimizations \
			$(use_enable openmp) \
			$(use_enable static-libs static)
		popd > /dev/null
	fi
}

src_compile() {
	pushd src/C/autotools > /dev/null
	emake
	popd > /dev/null
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		emake
		popd > /dev/null
	fi
	if use java; then
		pushd src/java > /dev/null
		eant dist-notest
		popd > /dev/null
	fi
}

src_test() {
	pushd src/C/autotools > /dev/null
	emake check
	popd > /dev/null
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		emake check
		popd > /dev/null
	fi
	if use java; then
		pushd src/java > /dev/null
		EANT_GENTOO_CLASSPATH="ant-junit4" ANT_TASKS="ant-junit4" eant test
		popd > /dev/null
	fi
}

src_install() {
	dodoc READ_Copyrights_Licenses.txt
	pushd src/C/autotools > /dev/null
	emake install DESTDIR="${D}"
	popd > /dev/null
	if use cxx; then
		pushd src/cxx/autotools > /dev/null
		emake install DESTDIR="${D}"
		docinto cxx
		dodoc ../CHANGES
		popd > /dev/null
	fi
	use static-libs || prune_libtool_files --all
	if use idl; then
		pushd src/idl > /dev/null
		insinto /usr/share/gnudatalanguage/healpix
		doins -r examples fits interfaces misc toolkit visu zzz_external
		doins HEALPix_startup
		docinto idl
		dodoc README.*
		popd > /dev/null
	fi
	if use java; then
		pushd src/java > /dev/null
		java-pkg_dojar dist/*.jar
		docinto java
		dodoc README CHANGES
		popd > /dev/null
	fi
	use doc && dodoc -r doc/html
}

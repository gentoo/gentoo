# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_BSFIX_NAME="build.xml build-unix.xml"
inherit autotools java-pkg-opt-2 java-ant-2

DESCRIPTION="A collection of file system and media management forensic analysis tools"
HOMEPAGE="https://www.sleuthkit.org/sleuthkit/"
# TODO: sqlite-jdbc does not exist in the tree, we bundle it for now
#		See: https://bugs.gentoo.org/690010
# TODO: SparseBitSet does not exist in the tree, we bundle it for now
#		See: https://bugs.gentoo.org/690012
# TODO: Upstream uses a very specific version of libewf which is not in
#       the tree anymore. So we statically compile and link to sleuthkit.
#       Hopefully upstream will figure something out in the future.
#		See: https://bugs.gentoo.org/689752
# TODO: gson-2.8.5 does not exist in the tree. Building it seems to
# 		require Java 9. We have Java 11 in the tree but I don't see a
# 		way to use it as a gentoo-vm in order to build gson. Sleuthkit
# 		upstream still uses Java 8.
# 		See: https://bugs.gentoo.org/706274
# TODO: commons-validator-1.6 does not exist in the tree. The latest version
#		as of writing this ebuild is 1.4.1, for which the build fails. As
#		per #711930, this is a security sensitive bump. We're gonna fetch
#		the jar file here and file a bug request for a bump as well:
#		    https://bugs.gentoo.org/721020
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz
	java? (
		https://repo1.maven.org/maven2/com/google/code/gson/gson/2.8.5/gson-2.8.5.jar
		http://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.25.2/sqlite-jdbc-3.25.2.jar
		http://repo1.maven.org/maven2/com/zaxxer/SparseBitSet/1.1/SparseBitSet-1.1.jar
		https://repo1.maven.org/maven2/commons-validator/commons-validator/1.6/commons-validator-1.6.jar
	)
	ewf? ( https://github.com/sleuthkit/libewf_64bit/archive/VisualStudio_2010.tar.gz -> sleuthkit-libewf_64bit-20130416.tar.gz )"

LICENSE="BSD CPL-1.0 GPL-2+ IBM java? ( Apache-2.0 )"
SLOT="0/13" # subslot = major soname version
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="aff doc ewf java postgres static-libs test +threads zlib"
RESTRICT="!test? ( test )"

#
# Note: It is not possible to move the dep on dev-java/jdbc-postgresql
# inside a conditional postgres? block because java sources import
# org.postgres unconditionally as of writing this (version 4.6.4). The
# postgres USE flag will be used for the TSK postgresql support however.
#
DEPEND="
	dev-db/sqlite:3
	dev-lang/perl:*
	aff? ( app-forensics/afflib )
	ewf? ( sys-libs/zlib )
	java? (
		>=dev-java/c3p0-0.9.5:0
		dev-java/commons-lang:3.1
		dev-java/guava:20
		>=dev-java/jdbc-postgresql-9.4:0
		>=dev-java/joda-time-2.4:0
	)
	postgres? ( dev-db/postgresql:= )
	zlib? ( sys-libs/zlib )
"
# TODO: add support for not-in-tree libraries libvhdi and libvmdk
# libvhdi: https://github.com/libyal/libvhdi
# libvmdk: https://github.com/libyal/libvmdk
# DEPEND="${DEPEND}
# 	vhdi? ( dev-libs/libvhdi )
# 	vmdk? ( dev-libs/libvmdk )
# "

RDEPEND="${DEPEND}
	java? (
		|| (
			virtual/jre:1.8
			virtual/jdk:1.8
		)
	)
"
DEPEND="${DEPEND}
	java? ( virtual/jdk:1.8 )
	doc? ( app-doc/doxygen )
	test? ( >=dev-util/cppunit-1.2.1 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.0-tools-shared-libs.patch
	"${FILESDIR}"/${PN}-4.6.4-default-jar-location-fix.patch
)

src_unpack() {
	local f

	unpack ${P}.tar.gz

	if use ewf; then
		pushd "${T}" &>/dev/null || die
		unpack sleuthkit-libewf_64bit-20130416.tar.gz
		export TSK_LIBEWF_SRCDIR="${T}"/libewf_64bit-VisualStudio_2010
		popd &>/dev/null || die
	fi

	# Copy the jar files that don't exist in the tree yet
	if use java; then
		TSK_JAR_DIR="${T}/lib"
		mkdir "${TSK_JAR_DIR}" || die
		for f in ${A}; do
			if [[ ${f} =~ .jar$ ]]; then
				cp "${DISTDIR}"/"${f}" "${TSK_JAR_DIR}" || die
			fi
		done
		export TSK_JAR_DIR
	fi
}

tsk_prepare_libewf() {
	# Inlining breaks the compilation, disable it
	sed -e 's/LIBUNA_INLINE inline/LIBUNA_INLINE/' \
		-i "${TSK_LIBEWF_SRCDIR}"/libuna/libuna_inline.h || die
}

src_prepare() {
	use ewf && tsk_prepare_libewf

	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die

		# Prevent "make install" from installing
		# jar files under /usr/share/java
		# We'll use the java eclasses for this
		# See: https://github.com/sleuthkit/sleuthkit/pull/1379
		sed -e '/^jar_DATA/ d;' -i Makefile.am || die

		java-pkg-opt-2_src_prepare

		popd &>/dev/null || die
	fi

	# Override the doxygen output directories
	if use doc; then
		sed -e "/^OUTPUT_DIRECTORY/ s|=.*$|= ${T}/doc|" \
			-i tsk/docs/Doxyfile \
			-i bindings/java/doxygen/Doxyfile || die
	fi

	# It's safe to call this even after java-pkg-opt-2_src_prepare
	# because future calls to eapply_user do nothing and return 0
	default

	eautoreconf
}

tsk_compile_libewf() {
	local myeconfargs=(
		--prefix=/
		--libdir=/lib
		--enable-static
		--disable-shared
		--disable-winapi
		--without-libbfio
		--with-zlib
		--without-bzip2
		--without-libhmac
		--without-openssl
		--without-libuuid
		--without-libfuse

		--with-libcstring=no
		--with-libcerror=no
		--with-libcdata=no
		--with-libclocale=no
		--with-libcnotify=no
		--with-libcsplit=no
		--with-libuna=no
		--with-libcfile=no
		--with-libcpath=no
		--with-libbfio=no
		--with-libfcache=no
		--with-libfvalue=no

	)
	# We want to contain our build flags
	local CFLAGS="${CFLAGS}"
	local LDFLAGS="${LDFLAGS}"

	pushd "${TSK_LIBEWF_SRCDIR}" &>/dev/null || die

	# Produce relocatable code
	CFLAGS+=" -fPIC"
	LDFLAGS+=" -fPIC"
	econf "${myeconfargs[@]}"

	# Do not waste CPU cycles on building ewftools
	sed -e '/ewftools/ d' -i Makefile || die
	emake

	# Only install the headers and the library
	emake -C libewf DESTDIR="${T}"/image install
	emake -C include DESTDIR="${T}"/image install
	find "${T}"/image -name '*.la' -delete || die

	popd &>/dev/null || die
}

src_configure() {
	local myeconfargs=(
		--enable-offline="${TSK_JAR_DIR}"
		$(use_enable java)
		$(use_enable static-libs static)
		$(use_enable threads multithreading)
		$(use_with aff afflib)
		$(use_with zlib)
	)
	# Workaround the automagic detection of postgresql
	local -x ac_cv_lib_pq_PQlibVersion="$(usex postgres)"
	# TODO: add support for non-existing libraries libvhdi and libvmdk
	# myeconfargs+=(
	# 	$(use_with vhdi libvhdi)
	# 	$(use_with vmdk libvmdk)
	# )
	myeconfargs+=(
		--without-libvhdi
		--without-libvmdk
	)

	use ewf && tsk_compile_libewf
	myeconfargs+=( $(use_with ewf libewf "${T}"/image) )

	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die
		java-ant-2_src_configure
		popd &>/dev/null || die
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Give it an existing bogus ivy home #672220
	local -x IVY_HOME="${T}"

	# Create symlinks of jars for the required dependencies
	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die

		java-pkg_jar-from --into "${TSK_JAR_DIR}" c3p0
		java-pkg_jar-from --into "${TSK_JAR_DIR}" commons-lang:3.1
		java-pkg_jar-from --into "${TSK_JAR_DIR}" guava:20
		java-pkg_jar-from --into "${TSK_JAR_DIR}" jdbc-postgresql
		java-pkg_jar-from --into "${TSK_JAR_DIR}" joda-time

		popd &>/dev/null || die
	fi

	# Create the doc output dirs if requested
	if use doc; then
		mkdir -p "${T}"/doc/{api-docs,jni-docs} || die
	fi

	emake all $(usex doc api-docs "")
}

src_install() {
	local f

	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die

		java-pkg_newjar "dist/${P}.jar" "${PN}.jar"

		# Install the bundled jar files
		pushd "${TSK_JAR_DIR}" &>/dev/null || die
		for f in *; do
			# Skip the symlinks java-pkg_jar-from created
			[[ -f ${f} ]] || continue

			# Strip the version numbers as per eclass recommendation
			[[ ${f} =~ -([0-9]+\.)+jar$ ]] || continue

			java-pkg_newjar "${f}" "${f/${BASH_REMATCH[0]}/.jar}"
		done
		popd &>/dev/null || die

		popd &>/dev/null || die
	fi

	default

	# It unconditionally builds both api and jni docs
	# We install conditionally based on the provided use flags
	if use doc; then
		dodoc -r "${T}"/doc/api-docs
		use java && dodoc -r "${T}"/doc/jni-docs
	fi

	find "${D}" -name '*.la' -delete || die
}

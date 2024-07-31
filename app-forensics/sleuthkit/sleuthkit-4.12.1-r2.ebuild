# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools java-pkg-opt-2

DESCRIPTION="A collection of file system and media management forensic analysis tools"
HOMEPAGE="https://www.sleuthkit.org/sleuthkit/"
# TODO: sqlite-jdbc does not exist in the tree, we bundle it for now
#		See: https://bugs.gentoo.org/690010
# TODO: Upstream uses a very specific version of libewf which is not in
#       the tree anymore. So we statically compile and link to sleuthkit.
#       Hopefully upstream will figure something out in the future.
#		See: https://bugs.gentoo.org/689752
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz
	java? (
		https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.42.0.0/sqlite-jdbc-3.42.0.0.jar
	)
	ewf? ( https://github.com/sleuthkit/libewf_64bit/archive/VisualStudio_2010.tar.gz
			-> sleuthkit-libewf_64bit-20130416.tar.gz )"

LICENSE="BSD CPL-1.0 GPL-2+ IBM java? ( Apache-2.0 )"
SLOT="0/19" # subslot = major soname version
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="aff doc ewf java static-libs test +threads zlib"
RESTRICT="!test? ( test )"

DEPEND="
	dev-db/sqlite:3
	dev-lang/perl:*
	aff? ( app-forensics/afflib )
	ewf? ( sys-libs/zlib )
	java? (
		>=dev-java/c3p0-0.9.5.5:0
		dev-java/commons-lang:3.6
		>=dev-java/commons-validator-1.6:0
		>=dev-java/gson-2.8.5:0
		dev-java/guava:0
		>=dev-java/jdbc-postgresql-9.4:0
		>=dev-java/joda-time-2.4:0
		>=dev-java/mchange-commons-0.2.20:0
		dev-java/sparsebitset:0
	)
	zlib? ( sys-libs/zlib )
"
# TODO: add support for not-in-tree libraries:
# libvhdi: https://github.com/libyal/libvhdi
# libvmdk: https://github.com/libyal/libvmdk
# libvslvm: https://github.com/libyal/libvslvm
#   Upstream also says "A stand-alone version of libbfio is needed
#   to allow libvslvm to directly read from a TSK_IMAGE." Not sure
#   what it means yet.
#
# DEPEND="${DEPEND}
# 	vhdi? ( dev-libs/libvhdi )
# 	vmdk? ( dev-libs/libvmdk )
#   vslvm? ( dev-libs/libvslvm dev-libs/libbfio )
# "

RDEPEND="${DEPEND}
	java? ( virtual/jre:1.8 )
"
DEPEND="${DEPEND}
	java? ( virtual/jdk:1.8 )
	test? (
		>=dev-util/cppunit-1.2.1
	)
"
BDEPEND="
	virtual/pkgconfig
	java? ( >=dev-java/ant-1.10.14-r3:0 )
	doc? ( app-text/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.0-tools-shared-libs.patch
	"${FILESDIR}"/${PN}-4.6.4-default-jar-location-fix.patch
	"${FILESDIR}"/${PN}-4.10.1-exclude-usr-local.patch
	"${FILESDIR}"/${PN}-4.12.0-configure-ac-test-fix.patch
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

	# Do not pass '-Werror'. This is overkill for user builds.
	sed -e '/AM_CXXFLAGS/ s/-Werror//g' \
		-i tsk/util/Makefile.am \
		-i tsk/pool/Makefile.am || die
	# Remove -static from LDFLAGS because it doesn't actually create
	# a static binary. It confuses libtool, who then inserts rpath
	sed -e '/LDFLAGS/ s/-static//' \
		-i tools/pooltools/Makefile.am || die

	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die

		# Prevent "make install" from installing
		# jar files under /usr/share/java
		# We'll use the java eclasses for this
		# See: https://github.com/sleuthkit/sleuthkit/pull/1379
		sed -e '/^jar_DATA/ d;' -i Makefile.am || die

		java-pkg-opt-2_src_prepare

		popd &>/dev/null || die

		# Call ant with jar target for case-uco.
		# The default invocation of ant tries to
		# run junit tests, which there are none.
		# It ends up failing with:
		# junit.framework.AssertionFailedError: No tests found in org.sleuthkit.caseuco.TestSuite
		sed -e '/\tant \$(ant_args)/ s|$| jar|' \
			-i "${S}"/case-uco/java/Makefile.am \
			|| die

		export ANT_OPTS=" -Dant.build.javac.source=$(java-pkg_get-source)"
		export ANT_OPTS+=" -Dant.build.javac.target=$(java-pkg_get-target)"

		java-pkg-opt-2_src_prepare
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
		$(use_enable test cppunit)
		$(use_enable threads multithreading)
		$(use_with aff afflib)
		$(use_with zlib)
	)
	# TODO: add support for non-existing libraries:
	# myeconfargs+=(
	# 	$(use_with vhdi libvhdi)
	# 	$(use_with vmdk libvmdk)
	# 	$(use_with vslvm libvslvm)
	# 	$(use_with vslvm libbfio) # not a typo
	# )
	myeconfargs+=(
		--without-libvhdi
		--without-libvmdk
		--without-libvslvm
		--without-libbfio
	)

	use ewf && tsk_compile_libewf
	myeconfargs+=( $(use_with ewf libewf "${T}"/image) )

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Give it an existing bogus ivy home #672220
	local -x IVY_HOME="${T}"

	# Create symlinks of jars for the required dependencies
	if use java; then
		java-pkg_jar-from --into "${TSK_JAR_DIR}" c3p0
		java-pkg_jar-from --into "${TSK_JAR_DIR}" commons-lang:3.6
		java-pkg_jar-from --into "${TSK_JAR_DIR}" commons-validator
		java-pkg_jar-from --into "${TSK_JAR_DIR}" gson
		java-pkg_jar-from --into "${TSK_JAR_DIR}" guava
		java-pkg_jar-from --into "${TSK_JAR_DIR}" jdbc-postgresql
		java-pkg_jar-from --into "${TSK_JAR_DIR}" joda-time
		java-pkg_jar-from --into "${TSK_JAR_DIR}" mchange-commons
		java-pkg_jar-from --into "${TSK_JAR_DIR}" sparsebitset

		# case-uco needs gson and expects it under case-uco/java/lib
		# symlink it to the jar dir we create for java bindings
		ln -s "${TSK_JAR_DIR}" "${S}"/case-uco/java/lib || die
		ln -s ./gson.jar "${TSK_JAR_DIR}"/gson-2.8.5.jar || die
	fi

	# Create the doc output dirs if requested
	if use doc; then
		mkdir -p "${T}"/doc/{api-docs,jni-docs} || die
	fi

	emake all $(usex doc api-docs "")
}

src_install() {
	# Give it an existing bogus ivy home #756766
	local -x IVY_HOME="${T}"
	local f

	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die

		# Install case-uco
		pushd "${S}"/case-uco/java &>/dev/null || die
		java-pkg_newjar "dist/${PN}-caseuco-${PV}".jar "${PN}-caseuco.jar"
		popd || die

		# Install the bundled jar files as well as the
		# sleuthkit jar installed here by case-uco
		pushd "${TSK_JAR_DIR}" &>/dev/null || die
		for f in *; do
			# Skip the symlinks java-pkg_jar-from created
			[[ -L ${f} ]] && continue

			# Strip the version numbers as per eclass recommendation
			[[ ${f} =~ -([0-9]+\.)+jar$ ]] || continue

			java-pkg_newjar "${f}" "${f/${BASH_REMATCH[0]}/.jar}"
		done
		popd &>/dev/null || die

		popd &>/dev/null || die
	fi

	default
	# Default install target for case-uco installs the jar in the wrong place
	rm -r "${ED}"/usr/share/java

	# It unconditionally builds both api and jni docs
	# We install conditionally based on the provided use flags
	if use doc; then
		dodoc -r "${T}"/doc/api-docs
		use java && dodoc -r "${T}"/doc/jni-docs
	fi

	find "${D}" -name '*.la' -delete || die
}

src_test() {
	emake -C "${S}"/unit_tests check
}

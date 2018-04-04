# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_BSFIX_NAME="build.xml build-unix.xml"
inherit autotools java-pkg-opt-2 java-ant-2

DESCRIPTION="A collection of file system and media management forensic analysis tools"
HOMEPAGE="https://www.sleuthkit.org/sleuthkit/"
# TODO: sqlite-jdbc does not exist in the tree, we bundle it for now
# TODO: Upstream uses a very specific version of libewf which is not in
#       the tree anymore. So we statically compile and link to sleuthkit.
#       Hopefully upstream will figure something out in the future.
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz
	java? ( http://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.8.11/sqlite-jdbc-3.8.11.jar )
	ewf? ( https://dev.gentoo.org/~gokturk/distfiles/app-forensics/libewf/libewf-20130128.tar.gz )"

LICENSE="BSD CPL-1.0 GPL-2+ IBM java? ( Apache-2.0 )"
SLOT="0/13" # subslot = major soname version
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="aff doc ewf java static-libs test +threads zlib"

DEPEND="
	dev-db/sqlite:3
	dev-lang/perl:*
	aff? ( app-forensics/afflib )
	ewf? ( sys-libs/zlib )
	java? (
		>=virtual/jdk-1.8:*
		>=dev-java/c3p0-0.9.5:0
		>=dev-java/jdbc-postgresql-9.4:0
	)
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.8:= )
"
DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-util/cppunit-1.2.1 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.0-tools-shared-libs.patch
)

src_unpack() {
	local f

	unpack ${P}.tar.gz

	# Ick, the upstream is stuck at libewf-20130128 which is
	# not even in the tree anymore. So we have to bundle it.
	if use ewf; then
		pushd "${T}" &>/dev/null || die
		unpack libewf-20130128.tar.gz
		export TSK_LIBEWF_SRCDIR="${T}"/libewf-20130128
		popd &>/dev/null || die
	fi

	# Copy the jar files that don't exist in the tree yet
	if use java; then
		TSK_JAR_DIR="${S}/bindings/java/lib"
		mkdir "${TSK_JAR_DIR}" || die
		for f in ${A}; do
			if [[ ${f} =~ .jar$ ]]; then
				cp "${DISTDIR}"/"${f}" "${TSK_JAR_DIR}" || die
			fi
		done
		export TSK_JAR_DIR
	fi
}

src_prepare() {
	if use ewf; then
		# Yeah, libewf-20130128 obviously doesn't just nicely compile
		sed -e 's/LIBUNA_INLINE inline/LIBUNA_INLINE/' \
			-i "${TSK_LIBEWF_SRCDIR}"/libuna/libuna_inline.h || die
	fi

	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die

		# Prevent "make install" from installing
		# jar files under /usr/share/java
		# We'll use the java eclasses for this
		sed -e '/^jar_DATA/ d;' -i Makefile.am || die

		# Disable dependency retrieval using ivy
		# We will handle it ourselves
		sed -e '/name="compile"/ s/, retrieve-deps//' \
			-e '/name="dist-/ s/, init-ivy//g' \
			-i build.xml || die

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

	popd &>/dev/null || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable java)
		$(use_enable static-libs static)
		$(use_enable threads multithreading)
		$(use_with aff afflib)
		$(use_with ewf libewf)
		$(use_with zlib)
	)

	if use ewf; then
		tsk_compile_libewf
		myeconfargs+=( $(use_with ewf libewf "${T}"/image) )
	fi

	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die
		java-ant-2_src_configure
		popd &>/dev/null || die
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Create symlinks of jars for the required dependencies
	if use java; then
		pushd "${S}"/bindings/java &>/dev/null || die

		java-pkg_jar-from --into "${TSK_JAR_DIR}" c3p0
		java-pkg_jar-from --into "${TSK_JAR_DIR}" jdbc-postgresql

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

		java-pkg_dojar dist/${P}.jar

		# Install the bundled jar files
		pushd "${TSK_JAR_DIR}" &>/dev/null || die
		for f in *; do
			# Skip the symlinks java-pkg_jar-from created
			[[ -f ${f} ]] || continue

			# Strip the version numbers as per eclass recommendation
			[[ ${f} =~ -([0-9].)+.jar$ ]] || continue

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

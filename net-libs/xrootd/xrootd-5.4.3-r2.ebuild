# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP571="setuptools"

inherit cmake distutils-r1

DESCRIPTION="Extended ROOT remote file server"
HOMEPAGE="https://xrootd.slac.stanford.edu/"
SRC_URI="https://xrootd.slac.stanford.edu/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples fuse http kerberos +libxml2 python readline +server systemd test"

RESTRICT="!test? ( test )"

CDEPEND="acct-group/xrootd
	acct-user/xrootd
	dev-libs/openssl:0=
	sys-libs/zlib
	virtual/libcrypt:=
	fuse? ( sys-fs/fuse:0= )
	http? ( net-misc/curl:= )
	kerberos? ( virtual/krb5 )
	libxml2? ( dev-libs/libxml2:2= )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="${CDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen[dot]
		virtual/latex-base
		python? ( dev-python/sphinx )
	)
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		test? ( >=dev-python/pytest-7.1.2[${PYTHON_USEDEP}] )
	)
	test? ( dev-util/cppunit )
"
RDEPEND="${CDEPEND}
	dev-lang/perl
"
REQUIRED_USE="
	http? ( kerberos )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( server )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.3-crc32.patch
	"${FILESDIR}"/${PN}-5.4.3-no_automagic.patch
	"${FILESDIR}"/${PN}-5.4.3-cmake_no_python.patch
	"${FILESDIR}"/${PN}-5.4.3-python_tests_py3.patch
)

# xrootd plugins are not intended to be linked with,
# they are to be loaded at runtime by xrootd,
# see https://github.com/xrootd/xrootd/issues/447
QA_SONAME="/usr/lib.*/libXrd.*-$(ver_cut 1)\.so
	/usr/lib.*/libXrdClTests\.so"

pkg_setup() {
	use python && python_setup
}

src_prepare() {
	cmake_src_prepare

	if use python; then
		pushd "${S}"/bindings/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

# FIXME: support xrdec - currently only builds against bundled isa-l
src_configure() {
	local mycmakeargs=(
		-DENABLE_FUSE=$(usex fuse)
		-DENABLE_HTTP=$(usex http)
		-DENABLE_KRB5=$(usex kerberos)
		-DENABLE_LIBXML2=$(usex libxml2)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_READLINE=$(usex readline)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_VOMS=no
		-DFORCE_ENABLED=yes
		-DXRDCL_ONLY=$(usex server "no" "yes")
	)
	cmake_src_configure

	if use python; then
		pushd "${BUILD_DIR}"/bindings/python > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	cmake_src_compile
	if use doc; then
		doxygen Doxyfile || die
		if use python; then
			emake -C bindings/python/docs html
		fi
	fi
	if use python; then
		pushd "${BUILD_DIR}"/bindings/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

python_test() {
	epytest
}

src_test() {
	pushd "${BUILD_DIR}/tests" > /dev/null || die
	# There are more tests but since these are ones currently run by upstream in their CI,
	# let's follow their example.
	./common/test-runner ./XrdClTests/libXrdClTests.so "All Tests/UtilsTest/" || die
	./common/test-runner ./XrdClTests/libXrdClTests.so "All Tests/SocketTest/" || die
	./common/test-runner ./XrdClTests/libXrdClTests.so "All Tests/PollerTest/" || die
	popd > /dev/null || die

	# Python tests currently require manual configuration and start-up of an xrootd server.
	# TODO: get this to run properly.
	#use python && distutils-r1_src_test
}

src_install() {
	use doc && HTML_DOCS=( doxydoc/html/. )
	dodoc docs/ReleaseNotes.txt
	cmake_src_install
	find "${D}" \( -iname '*.md5' -o -iname '*.map' \) -delete || die

	# base configs
	insinto /etc/xrootd
	doins packaging/common/*.cfg

	fowners root:xrootd /etc/xrootd
	keepdir /var/log/xrootd
	fowners xrootd:xrootd /var/log/xrootd

	if use server; then
		local i
		for i in cmsd frm_purged frm_xfrd xrootd; do
			newinitd "${FILESDIR}"/${i}.initd ${i}
		done
		# all daemons MUST use single master config file
		newconfd "${FILESDIR}"/xrootd.confd xrootd
	fi

	if use python; then
		pushd "${BUILD_DIR}"/bindings/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die

		if use doc; then
			docinto python
			docompress -x "/usr/share/doc/${PF}/python/html"
			dodoc -r bindings/python/docs/build/html
		fi
		if use examples; then
			docinto python
			dodoc -r bindings/python/examples
		fi
	fi

	if use test; then
		for f in test-runner xrdshmap; do
			rm "${ED}"/usr/bin/${f} || die "Failed to remove test helper ${f} from installed tree"
		done
		rm "${ED}"/usr/$(get_libdir)/libXrdClTest*.so || die "Failed to remove test libraries from installed tree"
	fi
}

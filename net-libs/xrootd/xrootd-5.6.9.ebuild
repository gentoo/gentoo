# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517="setuptools"
DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	media-gfx/graphviz
	virtual/latex-base
	python? ( dev-python/sphinx )
"

inherit cmake docs distutils-r1 systemd

DESCRIPTION="Extended ROOT remote file server"
HOMEPAGE="https://xrootd.slac.stanford.edu/"
SRC_URI="https://xrootd.slac.stanford.edu/download/v${PV}/${P}.tar.gz"
LICENSE="LGPL-3+"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="ceph examples fuse http kerberos +libxml2 macaroons python readline scitokens +server systemd test xrdec"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	http? ( kerberos )
	macaroons? ( server http )
	python? ( ${PYTHON_REQUIRED_USE} )
	scitokens? ( server )
	test? ( server )
"

CDEPEND="acct-group/xrootd
	acct-user/xrootd
	dev-libs/openssl:0=
	sys-libs/zlib
	virtual/libcrypt:=
	ceph? ( sys-cluster/ceph )
	fuse? ( sys-fs/fuse:0= )
	http? (
		net-misc/curl:=
		net-libs/davix
	)
	kerberos? ( virtual/krb5 )
	libxml2? ( dev-libs/libxml2:2= )
	macaroons? ( dev-libs/libmacaroons )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	scitokens? ( dev-cpp/scitokens-cpp )
	systemd? ( sys-apps/systemd:= )
	xrdec? ( dev-libs/isa-l )
"
DEPEND="${CDEPEND}"
BDEPEND="
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		test? ( >=dev-python/pytest-7.1.2[${PYTHON_USEDEP}] )
	)
	test? (
		dev-cpp/gtest
		dev-util/cppunit
	)
"
RDEPEND="${CDEPEND}
	dev-lang/perl
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.4.3-python_tests_py3.patch
)

# xrootd plugins are not intended to be linked with,
# they are to be loaded at runtime by xrootd,
# see https://github.com/xrootd/xrootd/issues/447
QA_SONAME="/usr/lib.*/libXrd.*-$(ver_cut 1)\.so
	/usr/lib.*/libXrd.*Tests\.so"

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

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_ISAL=TRUE
		$(usex python "-DINSTALL_PYTHON_BINDINGS=FALSE" "")
		-DXRDCEPH_SUBMODULE=$(usex ceph)
		-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=$(usex libxml2 "no" "yes")
		-DCMAKE_DISABLE_FIND_PACKAGE_systemd=$(usex systemd "no" "yes")
		-DENABLE_FUSE=$(usex fuse)
		-DENABLE_HTTP=$(usex http)
		-DENABLE_KRB5=$(usex kerberos)
		-DENABLE_MACAROONS=$(usex macaroons)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_READLINE=$(usex readline)
		-DENABLE_SCITOKENS=$(usex scitokens)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_VOMS=no
		-DENABLE_XRDCL=yes
		-DENABLE_XRDCLHTTP=$(usex http)
		-DENABLE_XRDEC=$(usex xrdec)
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
	if use python; then
		pushd "${BUILD_DIR}"/bindings/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi

	docs_compile
	# secondary documentation for python bindings
	if use python && use doc; then
		emake -C bindings/python/docs html
	fi
}

python_test() {
	epytest
}

src_test() {
	cmake_src_test
	# Python tests currently require manual configuration and start-up of an xrootd server.
	# TODO: get this to run properly.
	#use python && distutils-r1_src_test
}

src_install() {
	dodoc docs/ReleaseNotes.txt
	cmake_src_install
	find "${ED}" \( -iname '*.md5' -o -iname '*.map' \) -delete || die

	if use server; then
		local i
		for i in cmsd frm_purged frm_xfrd xrootd; do
			newinitd "${FILESDIR}"/${i}.initd ${i}
		done
		# all daemons MUST use single master config file
		newconfd "${FILESDIR}"/xrootd.confd xrootd

		if use systemd; then
			systemd_dounit packaging/common/*.{service,socket}
		fi
	fi

	# base configs
	insinto /etc/xrootd
	doins packaging/common/*.cfg

	keepdir /etc/xrootd/config.d
	keepdir /var/log/xrootd

	fowners -R xrootd:xrootd /etc/xrootd
	fowners -R xrootd:xrootd /var/log/xrootd

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
		rm "${ED}"/usr/$(get_libdir)/libXrd*Test*.so || die "Failed to remove test libraries from installed tree"
	fi
}

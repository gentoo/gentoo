# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} python3_14t )
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
HOMEPAGE="https://xrootd.org/"
LICENSE="LGPL-3+"

SLOT="0/6"
IUSE="ceph examples fuse +http +kerberos +libxml2 macaroons python readline scitokens +server systemd test"

if [[ ${PV} =~ "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xrootd/xrootd.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://xrootd.web.cern.ch/download/v${PV}/${P}.tar.gz"
fi

RESTRICT="!test? ( test )"

REQUIRED_USE="
	http? ( server )
	macaroons? ( server http )
	python? ( ${PYTHON_REQUIRED_USE} )
	scitokens? ( server )
	test? ( http server )
"

CDEPEND="acct-group/xrootd
	acct-user/xrootd
	dev-libs/openssl:0=
	net-misc/curl:=
	virtual/zlib:=
	virtual/libcrypt:=
	ceph? ( sys-cluster/ceph )
	fuse? ( sys-fs/fuse:0= )
	kerberos? ( app-crypt/mit-krb5 )
	libxml2? ( dev-libs/libxml2:2= )
	macaroons? ( dev-libs/libmacaroons )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	scitokens? ( dev-cpp/scitokens-cpp )
	server? ( dev-libs/libzip:= )
	systemd? ( sys-apps/systemd:= )
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

# XRootD plugins are not intended to be linked with,
# they are loaded at runtime by the XRootD server.
# See https://github.com/xrootd/xrootd/issues/447
QA_SONAME="/usr/lib.*/libXrd.*-6\.so"

pkg_setup() {
	use python && python_setup
}

src_prepare() {
	cmake_src_prepare

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

src_configure() {
	local mycmakeargs=(
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
		-DENABLE_SERVER_TESTS=$(usex server)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_VOMS=no
		-DENABLE_XRDCL=yes
		-DENABLE_XRDEC=no
		-DENABLE_XRDOSSARC=$(usex server)
		-DFORCE_ENABLED=yes
		-DXRDCL_ONLY=$(usex server "no" "yes")
	)
	cmake_src_configure

	if use python; then
		pushd "${BUILD_DIR}"/python > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	cmake_src_compile
	if use python; then
		pushd "${BUILD_DIR}"/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi

	docs_compile
	# secondary documentation for python bindings
	if use python && use doc; then
		emake -C python/docs html
	fi
}

python_test() {
	epytest
}

src_test() {
	export CTEST_OUTPUT_ON_FAILURE=1

	local CMAKE_SKIP_TESTS=(
		# bug 937090, these fail on tmpfs, as they require
		# a filesystem with extended attributes
		$(usev server '
			XrdCl::LocalFileHandlerTest.XAttrTest
			XrdCl::FileTest.XAttrTest
			XrdCl::FileCopyTest.ThirdPartyCopyTest
			XrdCl::FileCopyTest.NormalCopyTest
			XrdCl::FileSystemTest.XAttrTest
			XrdCl::WorkflowTest.XAttrWorkflowTest
			XrdCl::WorkflowTest.CheckpointTest
			XRootD::authenticated_cluster
			XRootD::httpnoclient
			XRootD::xcachewithcsi
			XRootD::badredir
			XRootD::posix
		')
		# server fails to start due to long path to unix domain socket
		$(usev scitokens '
			XRootD::scitokens
			XRootD::tpc
		')
	)
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
			systemd_dounit systemd/*.{service,socket}
		fi
	fi

	# base configs
	insinto /etc/xrootd
	doins config/*.{cfg,conf,example}

	# client configs
	insinto /etc/xrootd/client.plugins.d
	doins config/client.plugins.d/*.conf

	if use python; then
		pushd "${BUILD_DIR}"/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die

		if use doc; then
			docinto python
			docompress -x "/usr/share/doc/${PF}/python/html"
			dodoc -r python/docs/build/html
		fi
		if use examples; then
			docinto python
			dodoc -r python/examples
		fi
	fi

	if use server && use test; then
		rm "${ED}"/usr/bin/xrdshmap || die "Failed to remove test binary ${f} from installed tree"
	fi
}

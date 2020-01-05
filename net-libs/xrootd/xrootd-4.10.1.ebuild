# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cmake-utils python-single-r1 user

DESCRIPTION="Extended ROOT remote file server"
HOMEPAGE="http://xrootd.org/"
SRC_URI="http://xrootd.org/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples fuse http kerberos python readline ssl test"
RESTRICT="!test? ( test )"

CDEPEND="
	sys-libs/zlib
	fuse? ( sys-fs/fuse:= )
	kerberos? ( virtual/krb5 )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${CDEPEND}
	doc? (
		app-doc/doxygen[dot]
		python? ( dev-python/sphinx )
	)
	test? ( dev-util/cppunit )
"
RDEPEND="${CDEPEND}
	dev-lang/perl
"
REQUIRED_USE="
	http? ( kerberos ssl )
	python? ( ${PYTHON_REQUIRED_USE} )
"

PATCHES=( "${FILESDIR}"/xrootd-4.8.3-crc32.patch )

# xrootd plugins are not intended to be linked with,
# they are to be loaded at runtime by xrootd,
# see https://github.com/xrootd/xrootd/issues/447
QA_SONAME="/usr/lib.*/libXrd*-4.so"

pkg_setup() {
	enewgroup xrootd
	enewuser xrootd -1 -1 "${EPREFIX}"/var/spool/xrootd xrootd
	use python && python_setup
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CRYPTO=$(usex ssl)
		-DENABLE_FUSE=$(usex fuse)
		-DENABLE_HTTP=$(usex http)
		-DENABLE_KRB5=$(usex kerberos)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_READLINE=$(usex readline)
		-DENABLE_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die
		if use python; then
			emake -C bindings/python/docs html
		fi
	fi
}

src_install() {
	use doc && HTML_DOCS=( doxydoc/html/. )
	dodoc docs/ReleaseNotes.txt
	cmake-utils_src_install
	find "${D}" \( -iname '*.md5' -o -iname '*.map' \) -delete || die

	# base configs
	insinto /etc/xrootd
	doins packaging/common/*.cfg

	fowners root:xrootd /etc/xrootd
	keepdir /var/log/xrootd
	fowners xrootd:xrootd /var/log/xrootd

	local i
	for i in cmsd frm_purged frm_xfrd xrootd; do
		newinitd "${FILESDIR}"/${i}.initd ${i}
	done
	# all daemons MUST use single master config file
	newconfd "${FILESDIR}"/xrootd.confd xrootd

	if use python; then
		python_optimize "${D}/$(python_get_sitedir)"

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
}
